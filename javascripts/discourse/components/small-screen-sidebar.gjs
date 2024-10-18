import Component from "@glimmer/component";
import { service } from "@ember/service";
import Sidebar from "discourse/components/sidebar";

export default class SmallScreenSidebar extends Component {
  @service site;
  @service capabilities;

  get shouldShow() {
    return this.site.narrowDesktopView || this.capabilities.isIpadOS;
  }

  <template>
    {{#if this.shouldShow}}
      <div class="sidebar-wrapper c-small-sidebar">
        <Sidebar />
      </div>
    {{/if}}
  </template>
}
