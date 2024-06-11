import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

export default class BlockOnline extends Component {
  @tracked online = null;

  constructor() {
    super(...arguments);

    ajax("/about.json").then((data) => {
      this.online = data.about.stats;
    });
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.online = null;
  }

  <template>
    <div
      class="block block-online"
      title="{{this.online.active_users_last_day}} users online the past 24 hours"
    >
      {{number this.online.active_users_last_day}}
      <span>{{i18n (themePrefix "blocks.online.label")}}</span>
    </div>
  </template>
}
