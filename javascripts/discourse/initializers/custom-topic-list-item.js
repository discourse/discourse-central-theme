import { htmlSafe } from "@ember/template"
import { findRawTemplate } from "discourse-common/lib/raw-templates"
import { withPluginApi } from "discourse/lib/plugin-api"

export default {
  name: "custom-topic-list-item",
  initialize() {
    withPluginApi("0.8.7", (api) => {
      api.modifyClass("component:topic-list-item", {
        renderTopicListItem() {
          const template = findRawTemplate("list/custom-topic-list-item")
          if (template) {
            this.set("topicListItemContents", htmlSafe(template(this)))
          }
        },
      })
    })
  },
}
