import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { action } from "@ember/object";
// import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import avatar from "discourse/helpers/avatar";
import concatClass from "discourse/helpers/concat-class";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

export default class BlockTopContributors extends Component {
  @tracked topContributors = null;
  @tracked period = this.args?.period || "weekly";
  @tracked count = parseInt(this.args?.count, 10) || 10;

  constructor() {
    super(...arguments);
    this.fetchTopContributors(this.period, this.count);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.topContributors = null;
  }

  get format() {
    if (this.args.format) {
      return `block--${this.args.format}`;
    }
  }

  get variant() {
    if (this.args.variant) {
      switch (this.args.variant) {
        case "b":
          return `block--${this.args.variant}`;
      }
    }
  }

  fetchTopContributors(period, count) {
    ajax(`/leaderboard/7.json?period=${period}`)
      .then((data) => {
        this.topContributors = data.users.slice(0, count);
      })
      .catch(() => {
        ajax(
          `/directory_items.json?period=${period}&order=likes_received`
        ).then((data) => {
          this.topContributors = data.directory_items.slice(0, count);
        });
      });
  }

  @action
  updatePeriod(event) {
    const newPeriod = event.target.value;
    this.period = newPeriod;
    this.fetchTopContributors(this.period, this.count);
  }

  <template>
    <div
      class={{concatClass
        "block block-chart block-top-contributors"
        this.format
        this.variant
      }}
    >
      <div class="block-chart__header">
        <h3>
          {{i18n (themePrefix "blocks.top_contributors.title")}}
        </h3>

        {{yield this.topContributors}}

        <select onchange={{this.updatePeriod}}>
          <option value="all">
            {{i18n "js.filters.top.all.title"}}
          </option>
          <option value="yearly">
            {{i18n "js.filters.top.yearly.title"}}
          </option>
          <option value="quarterly">
            {{i18n "js.filters.top.quarterly.title"}}
          </option>
          <option value="monthly">
            {{i18n "js.filters.top.monthly.title"}}
          </option>
          <option value="weekly" selected>
            {{i18n "js.filters.top.weekly.title"}}
          </option>
          <option value="daily">
            {{i18n "js.filters.top.today"}}
          </option>
        </select>
      </div>
      <ol class="block-chart__list">
        {{#each this.topContributors as |topContributor|}}
          <li class="block-chart__item">
            <div class="block-chart__img">
              <a
                href={{concat "/u/" topContributor.username}}
                data-user-card={{topContributor.username}}
              >
                {{avatar topContributor imageSize="medium"}}
              </a>
            </div>
            <div class="block-chart__info">
              <div class="block-chart__title">
                <a
                  href={{concat "/u/" topContributor.username}}
                  data-user-card={{topContributor.username}}
                >
                  {{!-- {{#if topContributor.name}}
                    {{topContributor.name}}
                  {{else}} --}}
                  {{htmlSafe topContributor.username}}
                  {{!-- {{/if}} --}}
                </a>
              </div>
              <div class="block-chart__details">
                <span>
                  {{number topContributor.total_score}}
                  {{i18n (themePrefix "blocks.top_contributors.unit")}}
                </span>
              </div>
            </div>
          </li>
        {{/each}}
      </ol>
      <div class="block-chart__expand">
        <a href={{concat "/leaderboard/7&period=" this.period}}>
          {{i18n "js.show_more"}}
        </a>
      </div>
    </div>
  </template>
}
