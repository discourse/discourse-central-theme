import Component from "@glimmer/component";
import { concat } from "@ember/helper";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import BlockBirthday from "../../components/blocks/birthday";
import BlockCta from "../../components/blocks/cta";
import BlockOnline from "../../components/blocks/online";
import BlockProfile from "../../components/blocks/profile";
import BlockTime from "../../components/blocks/time";
import BlockTopContributors from "../../components/blocks/top-contributors";
import BlockTopTopics from "../../components/blocks/top-topics";
import StickySidebar from "../../components/sticky-sidebar";

export default class RightBlocks extends Component {
  @service router;

  get blocks() {
    return settings.blocks;
  }

  get shouldRenderBlocks() {
    return (
      this.router.currentRoute.parent?.name === "discovery" &&
      this.router.currentRouteName !== "discovery.categories"
    );
  }

  @action
  blockify(block) {
    switch (block.name) {
      case "cta":
        return BlockCta;
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
    }
  }

  <template>
    {{#if this.shouldRenderBlocks}}
      <StickySidebar>
        <div class="blocks --right">
          <div class="blocks__wrapper">
            {{#each this.blocks as |row|}}
              <div
                style={{htmlSafe (concat "order:" row.order)}}
                class="blocks__row"
              >
                {{#each row.blocks as |block|}}
                  {{#let (this.blockify block) as |BlockComponent|}}
                    {{#if BlockComponent}}
                      {{component
                        BlockComponent
                        size=block.size
                        period=block.period
                        count=block.count
                        title=block.title
                        cta=block.cta
                        ctas=block.ctas
                        description=block.description
                        url=block.url
                      }}
                    {{/if}}
                  {{/let}}
                {{/each}}
              </div>
            {{/each}}
          </div>
        </div>
      </StickySidebar>
    {{/if}}
  </template>
}
