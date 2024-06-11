import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class Navigation extends Component {
  @service currentUser;
  @service router;
  @service site;

  <template>
    <a href="/" class="logo-temp">
      <img src={{this.site.siteSettings.site_logo_url}} />
    </a>
    {{! <h1 class="logo-temp"><a href="/">Discourse</a></h1> }}
  </template>
}
