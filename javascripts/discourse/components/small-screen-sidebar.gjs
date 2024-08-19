import Component from "@glimmer/component";
import { service } from "@ember/service";
import Sidebar from "discourse/components/sidebar";

export default class SmallScreenSidebar extends Component {
  @service site;

  <template>
    {{#if this.site.narrowDesktopView}}
      <div class="sidebar-wrapper c–small-sidebar">
        <Sidebar />
      </div>
    {{/if}}
  </template>
}
