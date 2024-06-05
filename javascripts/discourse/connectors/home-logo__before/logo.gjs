import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class Navigation extends Component {
  @service currentUser;
  @service router;

  <template>
    <h1 class="logo-temp"><a href="/">Discourse</a></h1>
  </template>
}
