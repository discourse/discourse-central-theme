import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import { defaultHomepage } from "discourse/lib/utilities";

export default class SidebarRight extends Component {
  @service router;

  get isHomepage() {
    const { currentRouteName } = this.router;
    return (
      currentRouteName === `discovery.${defaultHomepage()}` ||
      currentRouteName === `discovery.category` ||
      currentRouteName === `discovery.unread` ||
      currentRouteName === `discovery.top` ||
      currentRouteName === `discovery.latest`
    );
  }
}
