import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import BlockBirthday from "../../components/blocks/birthday";
import BlockOnline from "../../components/blocks/online";
import BlockProfile from "../../components/blocks/profile";
import BlockTime from "../../components/blocks/time";
import BlockTopContributors from "../../components/blocks/top-contributors";
import BlockTopTopics from "../../components/blocks/top-topics";
import StickySidebarComponent from "../../components/sticky-sidebar";

export default class BlocksComponent extends Component {
  @service currentUser;
  @service router;
  @service site;

  get blocks() {
    return settings.blocks;
  }

  @action
  blockify(block) {
    switch (block.name) {
      case "top_contributors":
        return BlockTopContributors;
      case "top_topics":
        return BlockTopTopics;
      case "time":
        return BlockTime;
      case "profile":
        return BlockProfile;
      case "online":
        return BlockOnline;
      case "birthday":
        return BlockBirthday;
      default:
        return null;
    }
  }

  <template>
    {{!log this.blocks}}
    <StickySidebarComponent>
      <div class="blocks">
        <div class="blocks__wrapper">
          {{#each this.blocks as |row|}}
            <div class="blocks__row">
              {{#each row.blocks as |block|}}
                {{#let (this.blockify block) as |BlockComponent|}}
                  {{#if BlockComponent}}
                    {{component
                      BlockComponent
                      size=block.size
                      period=block.period
                    }}
                  {{/if}}
                {{/let}}
              {{/each}}
            </div>
          {{/each}}
        </div>
      </div>
    </StickySidebarComponent>
  </template>
}
