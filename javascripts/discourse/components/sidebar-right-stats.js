import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";

export default class SidebarRightStats extends Component {
  @tracked stats = null;

  constructor() {
    super(...arguments);

    ajax("/about.json").then((data) => {
      this.stats = data.about.stats;
    });
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.stats = null;
  }
}
