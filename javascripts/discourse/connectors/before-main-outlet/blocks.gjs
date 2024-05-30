import Component from "@glimmer/component";
import { service } from "@ember/service";
import BlockProfile from "../../components/blocks/profile";
import BlockTopContributors from "../../components/blocks/top-contributors";
import BlockTopTopics from "../../components/blocks/top-topics";

export default class Blocks extends Component {
  @service currentUser;
  @service router;

  <template>
    <div class="blocks">

      <div class="blocks__row">
        <BlockProfile @format="2x2" />
      </div>
      <BlockTopContributors @count="5" />
      <BlockTopTopics @count="5" />
    </div>
  </template>
}