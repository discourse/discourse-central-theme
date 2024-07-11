import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class Navigation extends Component {
  @service siteSettings;

  <template>
    <a href="/" class="logo-temp">
      <img src={{this.siteSettings.site_logo_url}} />
    </a>
  </template>
}
