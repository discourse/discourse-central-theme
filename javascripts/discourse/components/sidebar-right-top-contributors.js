import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";

export default class SidebarRightTopContributors extends Component {
  @tracked topContributors = null;
  @tracked period = "weekly";

  constructor() {
    super(...arguments);

    const count = this.args?.params?.count || 10;

    this.fetchTopContributors(this.period, count);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.topContributors = null;
  }

  // Function to fetch top contributors based on period
  fetchTopContributors(period, count) {
    ajax(`/directory_items.json?period=${period}&order=likes_received`).then(
      (data) => {
        this.topContributors = data.directory_items.slice(1, count + 1);
      }
    );
  }

  // Action to update the period
  updatePeriod(newPeriod) {
    this.period = newPeriod;
    const count = this.args?.params?.count || 10;
    this.fetchTopContributors(this.period, count);
  }
}
