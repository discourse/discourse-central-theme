import Component from "@glimmer/component";
import { ajax } from "discourse/lib/ajax";
import { tracked } from "@glimmer/tracking";

export default class MiniStats extends Component {
  @tracked stats = null;

  constructor() {
    super(...arguments);

    ajax("/about.json").then((data) => {
      this.stats = data.about.stats;
    });
  }

  willDestroy() {
    this.stats = null;
  }
}
