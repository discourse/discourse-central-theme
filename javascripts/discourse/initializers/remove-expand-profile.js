import { withPluginApi } from "discourse/lib/plugin-api";

function removeProfileExpand(api) {
  api.modifyClass("controller:user", {
    pluginId: "remove-profile-expand",
    canExpandProfile: false,
    forceExpand: true,
  });
}

export default {
  name: "remove-profile-expand",
  initialize() {
    withPluginApi("0.10.1", removeProfileExpand);
  },
};
