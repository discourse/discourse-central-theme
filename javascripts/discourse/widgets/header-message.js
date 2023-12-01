import { createWidget } from "discourse/widgets/widget";
import RenderGlimmer from "discourse/widgets/render-glimmer";
import { hbs } from "ember-cli-htmlbars";

export default createWidget("header-message", {
  tagName: "li.header-dropdown-toggle",

  html() {
    return [
      new RenderGlimmer(this, "div.header-message", hbs`<HeaderMessage />`),
    ];
  },
});
