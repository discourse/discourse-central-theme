import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class Navigation extends Component {
  @service site;

  <template>
    <a href="/" class="logo-temp">
      <img src={{this.site.siteSettings.site_logo_url}} />
    </a>
  </template>
}
