import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import concatClass from "discourse/helpers/concat-class";

export default class BlockCta extends Component {
  @tracked title = this.args?.title;
  @tracked desc = this.args?.description;
  @tracked cta = this.args?.cta;
  @tracked url = this.args?.url;

  get size() {
    if (this.args.size) {
      return `block--${this.args.size}`;
    }
  }

  <template>
    <div class={{concatClass "block block-cta" this.size}}>
      <h4>{{this.title}}</h4>
      <p>{{this.desc}}</p>
      <a role="button" href={{this.url}}><span>{{this.cta}}</span></a>
    </div>
  </template>
}
