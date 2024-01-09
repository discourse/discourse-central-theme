import { withPluginApi } from "discourse/lib/plugin-api";
import SidebarLeft from "../components/sidebar-left";

export default {
  name: "left-sidebar-connector",

  initialize() {
    withPluginApi("1.14.0", (api) => {
      api.renderInOutlet("above-main-container", SidebarLeft);
    });
  },
};
