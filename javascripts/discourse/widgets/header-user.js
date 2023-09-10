import { createWidget } from "discourse/widgets/widget"
import RenderGlimmer from "discourse/widgets/render-glimmer"
import { hbs } from "ember-cli-htmlbars"

export default createWidget("header-user", {
  tagName: "li.header-dropdown-toggle.header-user",

  html() {
    return [new RenderGlimmer(this, "div", hbs`<HeaderUser />`)]
  },
})
