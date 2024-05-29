import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat, get } from "@ember/helper";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import willDestroy from "@ember/render-modifiers/modifiers/will-destroy";
import { inject as service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq, or } from "truth-helpers";
import avatar from "discourse/helpers/avatar";
import formatDate from "discourse/helpers/format-date";
import number from "discourse/helpers/number";
import replaceEmoji from "discourse/helpers/replace-emoji";
import i18n from "discourse-common/helpers/i18n";
import LikeToggle from "../../components/like-toggle";
import endsWithEllipsis from "../../helpers/ends-with-ellipsis";

export default class PostPrimary extends Component {
  @service currentUser;
  @service router;

  @tracked topic = this.args.outletArgs.topic;

  constructor() {
    super(...arguments);
    this.boundNavigate = this.navigate.bind(this, this.topic.lastUnreadUrl);
  }

  @action
  navigate(url, event) {
    const anchor = event.target.closest("a, button");

    if (anchor) {
      return;
    }

    event.preventDefault();
    this.router.transitionTo(url);
  }

  @action
  registerClickHandler(element) {
    element.parentElement.addEventListener("click", this.boundNavigate);
  }

  @action
  removeClickHandler(element) {
    if (this.boundNavigate) {
      element.parentElement.removeEventListener("click", this.boundNavigate);
    }
  }

  <template>
    {{log this.topic}}
    <div
      class="hidden"
      {{didInsert this.registerClickHandler}}
      {{willDestroy this.removeClickHandler}}
    >
    </div>

    <div class="topic__avatar">
      <a
        href={{get this.topic.posters "0.user.userPath"}}
        data-user-card={{get this.topic.posters "0.user.username"}}
      >
        {{avatar (get this.topic.posters "0.user") imageSize="medium"}}
      </a>
    </div>

    <div class="topic__author">
      <a
        class="topic__username"
        href={{get this.topic.posters "0.user.userPath"}}
        data-user-card={{get this.topic.posters "0.user.username"}}
      >
        {{get this.topic.posters "0.user.username"}}
      </a>
      <div class="topic__metadata">
        {{formatDate this.topic.createdAt format="medium" leaveAgo="true"}}
      </div>
    </div>

    {{#if (or this.topic.excerpt this.topic.image_url)}}

      <div class="topic__content">

        {{#if this.topic.excerpt}}

          <div class="topic__excerpt">
            {{replaceEmoji (htmlSafe this.topic.excerpt)}}
            {{#if (endsWithEllipsis this.topic.excerpt)}}
              <a href={{this.topic.firstPostUrl}} class="topic__readmore">
                {{i18n "js.read_more"}}
              </a>
            {{/if}}
          </div>

        {{/if}}

      </div>
    {{/if}}

    {{#unless (eq this.topic.posters.length 1)}}
      <div
        class={{if
          (eq this.topic.posters.0.extras "latest")
          "topic__replies --reverse"
          "topic__replies"
        }}
      >
        <ul>
          {{#each this.topic.posters as |poster index|}}
            {{#if (eq index 0)}}
              {{#if (eq poster.extras "latest")}}
                <li>
                  {{avatar poster.user imageSize="small"}}
                </li>
              {{/if}}
            {{else}}
              <li>
                {{avatar poster.user imageSize="small"}}
              </li>
            {{/if}}
          {{/each}}
        </ul>
        <a href={{this.topic.lastPostUrl}} class="topic__last-reply">
          <span>{{this.topic.lastPoster.user.username}}</span>
          {{formatDate this.topic.last_posted_at format="tiny"}}
        </a>

      </div>
    {{/unless}}

    <ul class="topic__actions">
      <li>
        <LikeToggle @topic={{this.topic}} />
      </li>
      <li>
        <a
          href={{concat "/t/" this.topic.slug "/" this.topic.id}}
          class="topic__reply-button"
        >
          {{#if (eq this.topic.replyCount 0)}}
            <span>
              {{i18n "js.topic.reply.title"}}
            </span>
          {{else}}
            {{number this.topic.replyCount}}
          {{/if}}
        </a>
      </li>
    </ul>
  </template>
}
