import { concat } from "@ember/helper";

const Banner = <template>
  <div class="block block-banner">
    {{#if @title}}
      <h1>
        {{@title}}
      </h1>
    {{/if}}

    {{#if @description}}
      <span class="block-banner__blurb">
        {{@description}}
      </span>
    {{/if}}

    {{#if @ctas}}
      <div class="block-banner__ctas">
        {{#each @ctas as |cta|}}
          <a href={{cta.url}} class={{concat "button--" cta.style}}>
            <span>{{cta.label}}</span>
          </a>
        {{/each}}
      </div>
    {{/if}}
  </div>
</template>;

export default Banner;
