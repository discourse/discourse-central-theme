import Component from "@glimmer/component";
import { service } from "@ember/service";
import BlockBirthday from "../../components/blocks/birthday";
import BlockOnline from "../../components/blocks/online";
import BlockProfile from "../../components/blocks/profile";
import BlockTime from "../../components/blocks/time";
import BlockTopContributors from "../../components/blocks/top-contributors";
import BlockTopTopics from "../../components/blocks/top-topics";

export default class Blocks extends Component {
  @service currentUser;
  @service router;

  <template>
    <div class="blocks">
      <div class="blocks__wrapper">
        <div class="blocks__row">
          <BlockTime @format="2x1" />
          <BlockProfile @format="2x2" />
          <BlockOnline @format="2x1" />
          <BlockBirthday @format="2x1" />
        </div>
        <BlockTopTopics @count="5" />
        <BlockTopContributors @count="5" />
      </div>
    </div>
  </template>
}
