import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import I18n from "discourse-i18n";

export default class BlockClock extends Component {
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
    const tz = this.currentUser
      ? this.currentUser.user_option.timezone
      : moment.tz.guess();

    this.formattedUserLocalTime = moment.tz(tz).format(I18n.t("dates.time"));
    this.formattedUserLocalDate = moment
      .tz(tz)
      .format(I18n.t("dates.full_no_year_no_time"));
  }
  <template>
    <div class="block block-time">
      <span class="block-time__date">{{this.formattedUserLocalDate}}</span>
      <span class="block-time__time">{{this.formattedUserLocalTime}}</span>
    </div>
  </template>
}
