import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import icon from "discourse/helpers/d-icon";

@classNames("topic-title-outlet", "back")
export default class Back extends Component {
  <template>
    {{#unless this.model.isPrivateMessage}}
      <a
        href={{this.model.category.url}}
        role="button"
        class="topic-back-button"
      >
        <span>{{icon "arrow-left"}}</span></a>
    {{/unless}}
  </template>
}
