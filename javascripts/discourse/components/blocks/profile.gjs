import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { inject as service } from "@ember/service";
import { htmlSafe } from "@ember/template";
// import { eq, or } from "truth-helpers";
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

  get hello() {
    const greetings = ["Hello", "Welcome", "Greetings", "Salutations"];

    const index = Math.floor(Math.random() * greetings.length);
    return greetings[index];
  }

  get size() {
    if (this.args.size) {
      return `block--${this.args.size}`;
    }
  }

  updateUserData(user) {
    this.banner = user.profile_background_upload_url;
    this.bio = user.bio_excerpt;
    this.website = user.website;
    this.website_name = user.website_name;
  }

  <template>
    <div class={{concatClass "block block-profile" this.size}}>
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

          {{#if this.currentUser.name}}
            <div class="block-profile__name-wrapper">
              <span class="block-profile__hello">
                {{this.hello}}
              </span>
              <span class="block-profile__name">
                {{this.currentUser.name}}
              </span>
            </div>
            <a
              class="block-profile__username"
              href={{concat "/u/" this.currentUser.username}}
            >
              {{this.currentUser.username}}
            </a>
          {{else}}
            <div class="block-profile__name-wrapper">
              <span class="block-profile__hello">
                {{this.hello}}
              </span>
              <span class="block-profile__name">
                {{this.currentUser.username}}
              </span>
            </div>
          {{/if}}

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
