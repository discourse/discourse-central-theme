import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
// import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

export default class BlockBirthday extends Component {
  @tracked randomBirthday = null;

  constructor() {
    super(...arguments);

    ajax("/cakeday/birthdays/today.json").then((data) => {
      const birthdays = data.birthdays;
      this.randomBirthday =
        birthdays[Math.floor(Math.random() * birthdays.length)];
    });
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.randomBirthday = null;
  }

  <template>
    {{#if this.randomBirthday}}

      <div class="block block-birthday">
        <a
          class="block-birthday__avatar"
          href={{concat "/u/" this.randomBirthday.username}}
          data-user-card={{this.randomBirthday.username}}
        >
          {{avatar this.randomBirthday "large"}}
        </a>
        <div class="block-birthday__message">
          <span>
            {{i18n (themePrefix "sidebar.right.mini.birthday.message")}}
          </span>
          <a
            class="block-birthday__name"
            href={{concat "/u/" this.randomBirthday.username}}
            data-user-card={{this.randomBirthday.username}}
          >
            {{this.randomBirthday.username}}
          </a>
        </div>
      </div>

    {{else}}

      <div class="block-birthday__fallback">
        ❤️
      </div>

    {{/if}}
  </template>
}
