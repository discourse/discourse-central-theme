import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";

export default class BlockBanner extends Component {
  @tracked title = this.args?.title;
  @tracked description = this.args?.description;
  @tracked ctas = this.args?.ctas;
  @tracked image = this.args?.image;

  <template>
    <div class="block block-banner">
      {{#if this.title}}
        <h1>
          {{this.title}}
        </h1>
      {{/if}}
      {{#if this.description}}
        <span class="block-banner__blurb">
          {{this.description}}
        </span>
      {{/if}}
      {{!log this.ctas}}
      {{#if this.ctas}}
        <div class="block-banner__ctas">
          {{#each this.ctas as |cta|}}
            <a href={{cta.url}} class={{concat "button--" cta.style}}>
              <span>{{cta.label}}</span>
            </a>
          {{/each}}
        </div>
      {{/if}}
    </div>
  </template>
}
