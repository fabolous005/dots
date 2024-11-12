#!/bin/bash

echo -e " \033[1;32m*\033[0m Reviewing files listed in /etc/portage/profile/package.provided"

for linenr in $(awk '/^## package/ {print NR}' /etc/portage/profile/package.provided); do
	PACKAGE=$(awk "NR == $((linenr + 1))" /etc/portage/profile/package.provided)
	IFS=' ' read -r _ _ RULE NR <<< $(sed -n "${linenr}p" /etc/portage/profile/package.provided)
	[ -n ${RULE} ] && [ ${RULE} == "fix" ] && continue
	[ -z ${NR} ] && NR=1

	PACKAGE_REVISION=$(echo "${PACKAGE}" | sed -n 's/.*\(-r[0-9]\+\).*/\1/p')
	PACKAGE="${PACKAGE/-r[[:digit:]]/}"
	PACKAGE_NAME="${PACKAGE%-*}"
	LATEST=$(ls -v1r /var/db/repos/*/"${PACKAGE%-*}"/*.ebuild | grep -v 9999 | sed -n "${NR}p")
	LATEST_REVISION=$(echo "${LATEST}" | sed -n 's/.*\(-r[0-9]\+\).*/\1/p')
	LATEST="${LATEST/-r[[:digit:]]/}"
	LATEST="${LATEST%.ebuild}"

	if [[ "${PACKAGE##*-}" == "${LATEST##*-}" ]]; then
		if [[ "${PACKAGE_REVISION}" == "${LATEST_REVISION}" ]]; then
			echo -e " \033[1;32m*\033[0m - Skipping ${PACKAGE_NAME}"
			exit 0;
		fi
		PACKAGE="${PACKAGE##*-}${PACKAGE_REVISION}"
		LATEST="${LATEST##*-}${LATEST_REVISION}"
		echo -e " \033[1;32m*\033[0m - Replacing ${PACKAGE} with ${LATEST} for ${PACKAGE_NAME}"
		sed -i "$((linenr + 1)) s/${PACKAGE}/${LATEST}/" /etc/portage/profile/package.provided
	else
		PACKAGE="${PACKAGE##*-}${PACKAGE_REVISION}"
		LATEST="${LATEST##*-}${LATEST_REVISION}"
		echo -e " \033[1;32m*\033[0m - Replacing ${PACKAGE} with ${LATEST} for ${PACKAGE_NAME}"
		sed -i "$((linenr + 1)) s|${PACKAGE}|${LATEST}|" /etc/portage/profile/package.provided
	fi
done
