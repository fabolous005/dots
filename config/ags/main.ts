import { Media } from "./media.js";

const win = Widget.Window({
  name: "mpris",
  anchor: ["top", "right"],
  child: Media(),
  exclusivity: "exclusive",
});

App.config({ style: "./style.css", windows: [win] });
