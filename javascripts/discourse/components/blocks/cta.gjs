import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
// eslint-disable-next-line no-unused-vars
import { concat } from "@ember/helper";
// eslint-disable-next-line no-unused-vars
import { service } from "@ember/service";
// eslint-disable-next-line no-unused-vars
import { htmlSafe } from "@ember/template";
// import { eq, or } from "truth-helpers";
// import avatar from "discourse/helpers/avatar";
import concatClass from "discourse/helpers/concat-class";
// import { ajax } from "discourse/lib/ajax";

export default class BlockCta extends Component {
  @tracked title = this.args?.title;
  @tracked desc = this.args?.description;
  @tracked cta = this.args?.cta;
  @tracked url = this.args?.url;

  constructor() {
    super(...arguments);
  }

  get size() {
    if (this.args.size) {
      return `block--${this.args.size}`;
    }
    return;
  }

  <template>
    <div class={{concatClass "block block-cta" this.size}}>
      <h4>{{this.title}}</h4>
      <p>{{this.desc}}</p>
      <a role="button" href={{this.url}}><span>{{this.cta}}</span></a>
    </div>
  </template>
}
