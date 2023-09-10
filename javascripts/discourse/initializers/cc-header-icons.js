import { withPluginApi } from "discourse/lib/plugin-api"

export default {
  initialize() {
    withPluginApi("0.8", (api) => {
      api.addToHeaderIcons("header-user")
      api.addToHeaderIcons("create-post")
    })
  },
}
