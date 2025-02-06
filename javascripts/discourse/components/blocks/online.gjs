import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

export default class Online extends Component {
  @tracked online;

  constructor() {
    super(...arguments);
    ajax("/about.json").then((data) => (this.online = data.about.stats));
  }

  <template>
    <div
      title="{{this.online.active_users_last_day}} users online the past 24 hours"
      class="block block-online"
    >
      {{number this.online.active_users_last_day}}
      <span>{{i18n (themePrefix "blocks.online.label")}}</span>
    </div>
  </template>
}
