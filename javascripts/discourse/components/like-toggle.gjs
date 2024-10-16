import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { getOwner } from "@ember/application";
import { fn, get } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { debounce } from "@ember/runloop";
import { service } from "@ember/service";
import { eq, notEq, or } from "truth-helpers";
import concatClass from "discourse/helpers/concat-class";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import icon from "discourse-common/helpers/d-icon";
import i18n from "discourse-common/helpers/i18n";

export default class LikeToggle extends Component {
  @service currentUser;

  @tracked likeToggled = this.args.topic.liked;
  @tracked likeCount = this.args.topic.like_count;
  @tracked loading = false;
  @tracked clickCounter = 0;

  get likeCountDisplay() {
    return this.likeCount;
  }

  @action
  toggleLikeDebounced(topic) {
    if (this.loading) {
      // console.log("Action is currently loading, please wait.");
      return;
    }

    this.clickCounter++;

    this.likeToggled = !this.likeToggled;
    this.likeCount += this.likeToggled ? 1 : -1;
    debounce(this, this.performToggleLike, topic, 1000); // 500ms delay
  }

  async performToggleLike(topic) {
    if (this.clickCounter % 2 === 0) {
      // console.log("Skipping redundant like.");
      this.clickCounter = 0;
      return;
    }
    this.loading = true;
    try {
      const topicPosts = await ajax(`/t/${topic.id}/post_ids.json`);
      if (topicPosts && topicPosts.post_ids.length) {
        const firstPost = topicPosts.post_ids[0];
        if (firstPost) {
          if (!this.likeToggled) {
            // Adjusted the logic here to match the updated state
            await ajax(`/post_actions/${firstPost}`, {
              type: "DELETE",
              data: { post_action_type_id: 2 },
            });
            // console.log("UNLIKED");
          } else {
            await ajax(`/post_actions`, {
              type: "POST",
              data: { id: firstPost, post_action_type_id: 2 },
            });
            // console.log("LIKED");
          }
        }
      }
    } catch (error) {
      // console.error("Error toggling like:", error);
      // Rollback UI changes in case of an error
      this.likeToggled = !this.likeToggled;
      this.likeCount += this.likeToggled ? 1 : -1;
      const dialog = getOwner(this).lookup("service:dialog");
      dialog.alert(
        this.likeToggled
          ? "Sorry, you can't remove that like. Please refresh."
          : "Sorry, you can't like that topic."
      );
    } finally {
      this.loading = false;
      this.clickCounter = 0;
    }
  }
  <template>
    <button
      disabled={{or
        (eq @topic.first_poster.username this.currentUser.username)
        (eq (get @topic.posters "0.user.username") this.currentUser.username)
      }}
      title={{if
        (eq @topic.first_poster.username this.currentUser.username)
        "You cannot like this post."
        (i18n "post_action_types.like.description")
      }}
      type="button"
      {{on "click" (fn this.toggleLikeDebounced @topic)}}
      class={{concatClass (if this.likeToggled "--liked") "topic__like-button"}}
    >
      {{icon "d-unliked"}}
      {{#if (notEq this.likeCount 0)}}
        {{number this.likeCount}}
      {{/if}}
    </button>
  </template>
}
