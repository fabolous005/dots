#!/bin/bash

# NOTE:
# for every function:
# $0 -> the name of this script eg. /etc/portage/repo.postsync.d/gentoo.sh
# $1 -> the URL the repository is synced from
# $2 -> the location of the repository

function local_einfo() {
	echo -e " \033[1;32m*\033[0m ${1}"
}

function local_eerror() {
	echo -e " \033[1;31m*\033[0m ${1}"
}

function patch() {
        cd /var/db/repos/febuild || exit
	local PN=
	local inner_patch=
	for patch in "${PATCH_EBUILDS[@]}"; do
		inner_patch="${patch%% *}"
		local_einfo "- Applying ${inner_patch#/etc/portage/patches/repos/"$REPO"/}"
		git apply "${patch%% *}" >/dev/null || echo "$(date '+%s') Applying ${patch%% *} failed while syncing $REPO" >> /home/fabian/.cache/messages

		PN=${patch%% *}
		PN=${PN#/etc/portage/patches/repos/"$REPO"/}
		PN=${PN%.patch}
		PN=${PN//%//}
		# Name patches like this: <category>%<package>%version
		ebuild /var/db/repos/"$REPO"/"$PN"/"${PN#*/}"-"${patch#* }".ebuild manifest >/dev/null || echo "$(date '+%s') Updating manifest failed while syncing $REPO" >> /home/fabian/.cache/messages
	done
}

function update_patch() {
	# regex to match any ebuild https://projects.gentoo.org/pms/8/pms.html
	# [0-9]+(\.[0-9]+)+([a-z])?(_alpha|_beta|_pre|_rc|_p)?([a-z])?(-r([0-9]))?.ebuild

	local PN=
	local current=
	local latest=
	for patch in /etc/portage/patches/repos/"$REPO"/*.patch; do
		PN=${patch#/etc/portage/patches/repos/"$REPO"/}
		PN=${PN%.patch}
		PN=${PN//%//}
		[ ! -d /var/db/repos/febuild/"$PN" ] && mkdir --parent /var/db/repos/febuild/"$PN" && COMMIT_FEBUILD=true

		source /home/fabian/coding/bash/etools/etools
		# TODO: should parse current from patch
		current="$(etools_current_version "$PN")"
		latest="$(etools_get_version "$PN")"

		if [[ "$current" != "$latest" ]]; then
			COMMIT_FEBUILD=true
			PATCH_EBUILDS+=("$patch $latest")
			cp /var/db/repos/"$REPO"/"$PN"/"${PN#*/}-$latest".ebuild /var/db/repos/febuild/"$PN"/
			[ -d /var/db/repos/"$REPO"/"$PN"/files ] && cp -r /var/db/repos/"$REPO"/"$PN"/files /var/db/repos/febuild/"$PN"/
			rm "/var/db/repos/febuild/$PN/${PN#*/}-$current.ebuild" 2>/dev/null
			local_einfo "- Updating ${patch#/etc/portage/patches/repos/"$REPO"/} from ${PN#*/}-$current to ${PN#*/}-$latest"
			sed -i "s/${PN#*/}-$current/${PN#*/}-$latest/g" "$patch" || \
				local_eerror "- Updating the patch to the newest version failed" && \
				echo "$(date '+%s') Updating ${patch#/etc/portage/patches/repos/"$REPO"/} failed" >> /home/fabian/.cache/messages
		else
			if ! ls /var/db/repos/febuild/"$PN" >/dev/null 2>&1; then
				cp /var/db/repos/"$REPO"/"$PN"/"${PN#*/}-$latest".ebuild /var/db/repos/febuild/"$PN"/ || \
					local_eerror "Copying $latest to febuild repo failed"
				[ -d /var/db/repos/"$REPO"/"$PN"/files ] && \
					cp -r /var/db/repos/"$REPO"/"$PN"/files /var/db/repos/febuild/"$PN"/
				COMMIT_FEBUILD=true
			fi
		fi
	done
}

function commit_febuild() {
	[ $COMMIT_FEBUILD == true ] && cd /var/db/repos/febuild && \
		pkgdev manifest || true && \
			git add . >>/dev/null && git commit -m "Postsync update $REPO" >>/dev/null && git push >>/dev/null || return 0;
}



# array of functions to be called
functions=("update_patch" "patch" "commit_febuild")

COMMIT_FEBUILD=false
PATCH_EBUILDS=()
REPO=$(basename "$0" .sh)


if [ "$1" == "$(basename "$0" .sh)" ]; then
        # for func in "${functions[@]}"; do
	for (( i = 0; i < ${#functions[@]}; i++)); do
                # call every function with all arguments since the 2nd
                # NOTE: !!! Not to be passed to the function !!!
                # $0 -> the scripts name
                # $1 -> repository name

                # NOTE: !!! passed to the function !!!
                # $2 -> the URL to sync the repository from
                # $3 -> the location where the repository is located
		local_einfo "Applying \033[1m${functions[$i]}\033[0m function"
                ${functions[$i]} "${@:2}"
		if [ "$?" -eq 0 ]; then
			local_einfo "\033[1m${functions[$i]}\033[0m function returned sccuessfully"
		else
			local_eerror "\033[1m${functions[$i]}\033[0m function exited unsuccessfully"
		fi
		(( i < ${#functions[@]} - 1 )) && local_einfo
        done
	exit 0
fi
