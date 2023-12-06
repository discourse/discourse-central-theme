import { hbs } from "ember-cli-htmlbars";
import RenderGlimmer from "discourse/widgets/render-glimmer";
import { createWidget } from "discourse/widgets/widget";

export default createWidget("header-message", {
  tagName: "li.header-dropdown-toggle.header-message",

  html() {
    return [
      new RenderGlimmer(this, "div.header-message", hbs`<HeaderMessage />`),
    ];
  },
});
