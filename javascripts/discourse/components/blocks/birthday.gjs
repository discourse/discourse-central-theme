import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import avatar from "discourse/helpers/avatar";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

export default class Birthday extends Component {
  @tracked randomBirthday;

  constructor() {
    super(...arguments);

    ajax("/cakeday/birthdays/today.json").then(({ birthdays }) => {
      this.randomBirthday =
        birthdays[Math.floor(Math.random() * birthdays.length)];
    });
  }

  <template>
    {{#if this.randomBirthday}}
      <div class="block block-birthday">
        <a
          href="/u/{{this.randomBirthday.username}}"
          data-user-card={{this.randomBirthday.username}}
          class="block-birthday__avatar"
        >
          {{avatar this.randomBirthday "large"}}
        </a>
        <div class="block-birthday__message">
          <span>
            {{i18n (themePrefix "sidebar.right.mini.birthday.message")}}
          </span>
          <a
            href="/u/{{this.randomBirthday.username}}"
            data-user-card={{this.randomBirthday.username}}
            class="block-birthday__name"
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
