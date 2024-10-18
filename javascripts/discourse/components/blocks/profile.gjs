import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { or } from "truth-helpers";
import avatar from "discourse/helpers/avatar";
import concatClass from "discourse/helpers/concat-class";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

export default class Profile extends Component {
  @service currentUser;

  @tracked banner;
  @tracked bio;
  @tracked website;
  @tracked websiteName;

  constructor() {
    super(...arguments);

    if (this.currentUser !== null) {
      ajax(`/u/${this.currentUser.username}.json`).then(({ user }) => {
        this.banner = user.profile_background_upload_url;
        this.bio = user.bio_excerpt;
        this.website = user.website;
        this.websiteName = user.website_name;
      });
    }
  }

  <template>
    <div
      class={{concatClass
        "block block-profile"
        (if @size (concat "block--" @size))
      }}
    >
      {{#if this.currentUser}}
        <div
          class="block-profile__banner"
          style={{if
            this.banner
            (htmlSafe (concat "background-image: url('" this.banner "')"))
          }}
        />

        <div class="block-profile__avatar">
          {{avatar this.currentUser "huge"}}
        </div>

        <div class="block-profile__info">
          <div class="block-profile__name-wrapper">
            <span class="block-profile__name">
              {{i18n
                (themePrefix "blocks.profile.hello")
                name=(or this.currentUser.name this.currentUser.username)
              }}
            </span>
          </div>

          {{#if this.currentUser.name}}
            <a
              href="/u/{{this.currentUser.username}}"
              class="block-profile__username"
            >
              {{this.currentUser.username}}
            </a>
          {{/if}}

          <span class="block-profile__bio">
            {{htmlSafe this.bio}}
          </span>

          {{#if this.website}}
            <span class="block-profile__link">
              <a href={{this.website}}>
                {{this.websiteName}}
              </a>
            </span>
          {{/if}}

          <LinkTo
            @route="preferences.profile"
            @model={{this.currentUser}}
            class="block-profile__edit"
          >
            <span>{{i18n "js.edit"}}</span>
          </LinkTo>
        </div>
      {{/if}}
    </div>
  </template>
}
