import Component from "@glimmer/component";
import { service } from "@ember/service";
import BlockProfile from "../../components/blocks/profile";

export default class Blocks extends Component {
  @service currentUser;
  @service router;

  <template>
    <div class="blocks">

      <BlockProfile />

    </div>
  </template>
}
