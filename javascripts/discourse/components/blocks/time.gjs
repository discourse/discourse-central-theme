import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { i18n } from "discourse-i18n";

export default class Time extends Component {
  @service currentUser;

  @tracked formattedUserLocalTime = "";
  @tracked formattedUserLocalDate = "";

  constructor() {
    super(...arguments);

    this.updateFormattedUserLocalTime();

    this.interval = setInterval(() => {
      this.updateFormattedUserLocalTime();
    }, 1000);
  }

  willDestroy() {
    super.willDestroy(...arguments);

    clearInterval(this.interval);
  }

  updateFormattedUserLocalTime() {
    const tz = this.currentUser?.user_option.timezone ?? moment.tz.guess();

    this.formattedUserLocalTime = moment.tz(tz).format(i18n("dates.time"));
    this.formattedUserLocalDate = moment
      .tz(tz)
      .format(i18n("dates.full_no_year_no_time"));
  }

  <template>
    <div class="block block-time">
      <span class="block-time__date">{{this.formattedUserLocalDate}}</span>
      <span class="block-time__time">{{this.formattedUserLocalTime}}</span>
    </div>
  </template>
}
