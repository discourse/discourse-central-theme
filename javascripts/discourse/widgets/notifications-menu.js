// withPluginApi("0.8", (api) => {
//     api.addToHeaderIcons("header-toggle-button");
//   });

import { createWidget } from "discourse/widgets/widget"
import RenderGlimmer from "discourse/widgets/render-glimmer"
import { hbs } from "ember-cli-htmlbars"

export default createWidget("notifications-menu", {
  tagName: "li.header-dropdown-toggle",

  html() {
    return [new RenderGlimmer(this, hbs`<NotificationsMenu />`)]
  },
})
