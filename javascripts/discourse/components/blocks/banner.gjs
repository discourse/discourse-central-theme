import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
// import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";
// import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

export default class BlockBanner extends Component {
  constructor() {
    super(...arguments);
  }

  <template>
    <div class="block block-banner">
      <h1>
        Welcome to the SambaNova developer community
      </h1>
      <span class="block-banner__blurb">
        Ask questions, start discussions, connect with other members of the
        community.
      </span>
      <a class="button--primary">
        <span>Learn more</span>
      </a>
    </div>
  </template>
}
