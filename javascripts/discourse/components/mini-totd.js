import Component from "@glimmer/component";
import { ajax } from "discourse/lib/ajax";
import { tracked } from "@glimmer/tracking";

export default class MiniTotd extends Component {
  @tracked topicOfTheDay = null;

  constructor() {
    super(...arguments);

    const period = "daily";

    ajax("/top.json?period=" + period).then((data) => {
      this.topicOfTheDay = data.topic_list.topics[0];
    });
  }

  willDestroy() {
    this.topicOfTheDay = null;
  }
}