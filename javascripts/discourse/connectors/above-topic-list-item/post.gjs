import Component from "@glimmer/component";
import { get } from "@ember/helper";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import willDestroy from "@ember/render-modifiers/modifiers/will-destroy";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq, or } from "truth-helpers";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";
import concatClass from "discourse/helpers/concat-class";
import formatDate from "discourse/helpers/format-date";
import number from "discourse/helpers/number";
import replaceEmoji from "discourse/helpers/replace-emoji";
import icon from "discourse-common/helpers/d-icon";
import i18n from "discourse-common/helpers/i18n";
import LikeToggle from "../../components/like-toggle";
import endsWithEllipsis from "../../helpers/ends-with-ellipsis";

export default class PostPrimary extends Component {
  @service router;
  @service discovery;

  constructor() {
    super(...arguments);
    this.boundNavigate = this.navigate.bind(this, this.topic.lastUnreadUrl);
  }

  get topic() {
    return this.args.outletArgs.topic;
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
    <div
      class="hidden"
      {{didInsert this.registerClickHandler}}
      {{willDestroy this.removeClickHandler}}
    >
    </div>

    <div class="topic__avatar">
      <UserLink @user={{get this.topic.posters "0.user"}}>
        {{avatar (get this.topic.posters "0.user") imageSize="medium"}}
        <UserAvatarFlair @user={{get this.topic.posters "0.user"}} />
      </UserLink>
    </div>

    <div class="topic__author">
      <UserLink
        @user={{get this.topic.posters "0.user"}}
        class="topic__username"
      >
        {{get this.topic.posters "0.user.username"}}
      </UserLink>

      <div class="topic__metadata">
        {{formatDate this.topic.createdAt format="medium" leaveAgo="true"}}

        {{#unless this.discovery.category}}
          {{#if this.topic.category.name}}
            <a
              href="/c/{{this.topic.category.slug}}/{{this.topic.category.id}}"
              title={{this.topic.category.description_text}}
              class={{concatClass
                "topic__category"
                (if this.topic.category.read_restricted "--locked")
              }}
            >
              {{this.topic.category.name}}
            </a>
          {{/if}}
        {{/unless}}
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
          (eq (get this.topic.posters "0.extras") "latest")
          "topic__replies --reverse"
          "topic__replies"
        }}
      >
        <ul>
          {{#each this.topic.posters as |poster index|}}
            {{#if (eq index 0)}}
              {{#if (eq poster.extras "latest")}}
                <li>
                  <UserLink @user={{poster.user}}>
                    {{avatar poster.user imageSize="small"}}
                  </UserLink>
                </li>
              {{/if}}
            {{else}}
              <li>
                <UserLink @user={{poster.user}}>
                  {{avatar poster.user imageSize="small"}}
                </UserLink>
              </li>
            {{/if}}
          {{/each}}
        </ul>

        <a href={{this.topic.lastPostUrl}} class="topic__last-reply">
          <span>
            {{htmlSafe
              (i18n
                (themePrefix "post.replied")
                name=this.topic.lastPoster.user.username
                timeago=(formatDate
                  this.topic.last_posted_at format="medium-with-ago"
                )
              )
            }}
          </span>
        </a>

      </div>
    {{/unless}}

    <ul class="topic__actions">
      {{#unless (eq this.topic.like_count 0)}}
        <li>
          <LikeToggle @topic={{this.topic}} />
        </li>
      {{/unless}}
      <li>
        <a
          href="/t/{{this.topic.slug}}/{{this.topic.id}}"
          class="topic__reply-button"
        >
          {{icon "reply"}}
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
