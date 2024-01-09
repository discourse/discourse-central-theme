import { apiInitializer } from "discourse/lib/api";
import CustomSidebarToggle from "../components/custom-sidebar-toggle";

export default apiInitializer("1.13.0", (api) => {
  api.renderInOutlet("before-header-logo", CustomSidebarToggle);
});