import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default class TopicListHeaderFilter extends Component {
  @service router;

  filterOptions = [
    { value: "latest", label: "Latest" },
    { value: "top", label: "Top" },
    { value: "mostviewed", label: "Most Viewed" },
    { value: "mostreplied", label: "Most Replied" },
    { value: "oldest", label: "Oldest" },
  ];

  constructor() {
    super(...arguments);

    console.log(this.router);
  }

  selectedOption = this.filterOptions[0];

  @action
  updateFilter(value) {
    const currentRoute = this.router.currentRoute;

    let redirectURL;
    switch (value) {
      case "latest":
        redirectURL = `discovery.latest`;
        break;
      case "top":
        redirectURL = `discovery.top`;
        break;
    }

    this.router.transitionTo(redirectURL);
  }
}
