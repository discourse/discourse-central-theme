import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat, get } from "@ember/helper";
import { inject as service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq, or } from "truth-helpers";
import avatar from "discourse/helpers/avatar";
import concatClass from "discourse/helpers/concat-class";
import { ajax } from "discourse/lib/ajax";

export default class BlockProfile extends Component {
  @service currentUser;

  @tracked banner = null;
  @tracked bio = null;
  @tracked website = null;
  @tracked website_name = null;

  constructor() {
    super(...arguments);

    if (this.currentUser !== null) {
      const currentUserUrl = "/u/" + this.currentUser.username + ".json";

      ajax(currentUserUrl).then((data) => {
        this.updateUserData(data.user);
      });
    }
  }

  get greeting() {
    const greetings = ["Hello", "Welcome", "Greetings", "Salutations"];

    const index = Math.floor(Math.random() * greetings.length);
    return greetings[index];
  }

  // get format() {
  //   const width = isNaN(this.args.width)
  //     ? ""
  //     : `--w: span ${this.args.width}; `;

  //   const height = isNaN(this.args.height)
  //     ? ""
  //     : `--h: span ${this.args.height}; `;

  //   return `${width}${height}`.trim();
  // }

  get format() {
    if (this.args.format) {
      return `block--${this.args.format}`;
    }
  }

  updateUserData(user) {
    this.banner = user.profile_background_upload_url;
    this.bio = user.bio_excerpt;
    this.website = user.website;
    this.website_name = user.website_name;
  }

  <template>
    <div class={{concatClass "block block-profile" this.format}}>
      {{#if this.currentUser}}

        <div
          class="block-profile__banner"
          style={{if
            this.banner
            (htmlSafe (concat "background-image: url('" this.banner "')"))
          }}
        />

        <div class="block-profile__avatar">
          ˝
          {{avatar this.currentUser "huge"}}
        </div>
        <div class="block-profile__info">
          <div class="block-profile__greeting">
            {{this.greeting}}
          </div>
          <div class="block-profile__name">
            <h3>
              {{#if this.currentUser.name}}
                {{this.currentUser.name}}
              {{else}}
                {{this.currentUser.username}}
              {{/if}}
            </h3>

            {{#if this.currentUser.name}}
              <div class="block-profile__username">
                <a href={{concat "/u/" this.currentUser.username}}>
                  {{this.currentUser.username}}
                </a>
              </div>
            {{/if}}
          </div>

          <span class="block-profile__bio">
            {{htmlSafe this.bio}}
          </span>

          {{#if this.website}}
            <span class="block-profile__link">
              <a href={{this.website}}>
                {{this.website_name}}
              </a>
            </span>
          {{/if}}

          <div class="block-profile__edit">
            Edit
          </div>
        </div>
      {{else}}
        <div class="block block-profile">
          <div class="block-profile__login">
            <button class="btn" type="button">
              Login
            </button>
          </div>
        </div>
      {{/if}}
    </div>
  </template>
}
