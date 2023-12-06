import { hbs } from "ember-cli-htmlbars";
import RenderGlimmer from "discourse/widgets/render-glimmer";
import { createWidget } from "discourse/widgets/widget";

export default createWidget("header-user", {
  tagName: "li.header-dropdown-toggle.header-user",

  html() {
    return [new RenderGlimmer(this, "div", hbs`<HeaderUser />`)];
  },
});
