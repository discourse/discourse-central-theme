import Component from "@glimmer/component";
import { concat } from "@ember/helper";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import BlockBanner from "../../components/blocks/banner";
import BlockBirthday from "../../components/blocks/birthday";
import BlockOnline from "../../components/blocks/online";
import BlockProfile from "../../components/blocks/profile";
import BlockTime from "../../components/blocks/time";
import BlockTopContributors from "../../components/blocks/top-contributors";
import BlockTopTopics from "../../components/blocks/top-topics";

export default class TopBlocks extends Component {
  @service router;

  get isHomepage() {
    switch (this.router.currentRoute.parent?.name) {
      case "discovery":
        return true;
      case "tags":
        return true;
      default:
        return false;
    }
  }

  get blocksBackground() {
    return settings.blocks_top_image;
  }

  get blocks() {
    return settings.blocks_top;
  }

  @action
  blockify(block) {
    switch (block.name) {
      case "banner":
        return BlockBanner;
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
    {{#if this.isHomepage}}
      {{#if this.blocks}}
        <div class="blocks --top">
          <div
            style={{htmlSafe
              (if
                this.blocksBackground
                (concat "background-image: url(" this.blocksBackground ")")
              )
            }}
            class="blocks__wrapper"
          >
            {{#each this.blocks as |row|}}
              <div
                style={{htmlSafe
                  (concat "order:" (if row.order row.order "0;"))
                }}
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
                        image=block.image
                      }}
                    {{/if}}
                  {{/let}}
                {{/each}}
              </div>
            {{/each}}
          </div>
        </div>
      {{/if}}
    {{/if}}
  </template>
}
