// withPluginApi("0.8", (api) => {
//     api.addToHeaderIcons("header-toggle-button");
//   });

import { hbs } from "ember-cli-htmlbars";
import RenderGlimmer from "discourse/widgets/render-glimmer";
import { createWidget } from "discourse/widgets/widget";

export default createWidget("header-create", {
  tagName: "li.header-dropdown-toggle",

  html() {
    return [new RenderGlimmer(this, "div", hbs`<HeaderCreate />`)];
  },
});
