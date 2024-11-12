import GLib from "gi://GLib";

const main = "/tmp/ags/main.js";
const user = "/home/fabian";
const entry = `${user}/.config/ags/main.ts`;

try {
  await Utils.execAsync([
    `${user}/.bun/bin/bun`,
    "build",
    entry,
    "--outfile",
    main,
    "--external",
    "resource://*",
    "--external",
    "gi://*",
    "--external",
    "file://*",
  ]);

  await import(`file://${main}`);
} catch (error) {
  console.error(error);
  App.quit();
}

export {};
