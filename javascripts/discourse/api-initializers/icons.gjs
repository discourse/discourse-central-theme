import { on } from "@ember/modifier";
import { LinkTo } from "@ember/routing";
import { eq, or } from "truth-helpers";
import avatar from "discourse/helpers/bound-avatar-template";
import routeAction from "discourse/helpers/route-action";
import { apiInitializer } from "discourse/lib/api";
import i18n from "discourse-common/helpers/i18n";
import DMenu from "float-kit/components/d-menu";

export default apiInitializer("1.0", (api) => {
  const currentUser = api.getCurrentUser();

  api.headerIcons.add("c-user", <template>
    <li class="c-user">
      <DMenu
        @placement="bottom-end"
        {{!-- @modalForMobile={{true}} --}}
        @identifier="c-user"
      >
        <:trigger>
          {{avatar currentUser.avatar_template "medium"}}
        </:trigger>
        <:content as |args|>
          {{! template-lint-disable no-invalid-interactive }}
          <div class="c-user-menu" {{on "click" args.close}}>
            <LinkTo
              @route="user.summary"
              @model={{currentUser}}
              class="c-user-menu__profile"
            >
              {{avatar currentUser.avatar_template "medium"}}
              <div class="c-user-menu__profile-info">
                <span class="c-user-menu__profile-name">
                  {{#if currentUser.name}}
                    <span>{{currentUser.name}}</span>
                  {{/if}}
                  <span>{{currentUser.username}}</span>
                </span>
                <span class="c-user-menu__profile-cta">
                  View your profile
                </span>
              </div>
            </LinkTo>
            <ul class="c-user-menu__links">
              <li data-name="messages">
                <LinkTo @route="userPrivateMessages" @model={{currentUser}}>
                  <span>
                    {{i18n "js.user.private_messages"}}
                  </span>
                </LinkTo>
              </li>
              <li data-name="drafts">
                <LinkTo @route="userActivity.drafts" @model={{currentUser}}>
                  <span>
                    {{i18n "js.drafts.label"}}
                  </span>
                </LinkTo>
              </li>
              <li data-name="invites">
                <LinkTo @route="userInvited" @model={{currentUser}}>
                  <span>
                    {{i18n "js.user.invited.title"}}
                  </span>
                </LinkTo>
              </li>

              <li data-name="preferences">
                <LinkTo @route="preferences" @model={{currentUser}}>
                  <span>
                    {{i18n "user.preferences"}}
                  </span>
                </LinkTo>
              </li>
              <li data-name="logout">
                <a role="button" onclick={{routeAction "logout"}}>
                  <span>
                    {{i18n "user.log_out"}}
                  </span>
                </a>
              </li>
            </ul>
            {{#if (or currentUser.moderator currentUser.admin)}}
              <ul class="c-user-menu__links">
                <li data-name="flagged">
                  <LinkTo @route="review.index">
                    <span>Flagged
                      {{#unless (eq currentUser.reviewable_count 0)}}
                        ({{currentUser.reviewable_count}})
                      {{/unless}}
                    </span>
                  </LinkTo>
                </li>

                <li data-name="groups">
                  <LinkTo @route="groups.index">
                    <span>
                      {{i18n "js.groups.index.title"}}
                    </span>
                  </LinkTo>
                </li>
                <li data-name="tags">
                  <LinkTo @route="tags.index">
                    <span>
                      {{i18n "js.tagging.tags"}}
                    </span>
                  </LinkTo>
                </li>
                <li data-name="admin">
                  <LinkTo @route="admin.dashboard.general">
                    <span>{{i18n "js.admin_title"}}</span>
                  </LinkTo>
                </li>
              </ul>
            {{/if}}
            <ul class="c-user-menu__footer">
              <li>
                <a href="/">
                  {{i18n "js.about.simple_title"}}
                </a>
              </li>
              <li>
                <a href="/">
                  {{i18n "js.tos"}}
                </a>
              </li>
              <li>
                <a href="/">
                  {{i18n "js.privacy_policy"}}
                </a>
              </li>
            </ul>
          </div>
        </:content>
      </DMenu>
    </li>
  </template>);

  api.headerIcons.add("c-create", <template>
    <li class="c-create">
      <DMenu
        @placement="bottom-end"
        {{!-- @modalForMobile={{true}} --}}
        @identifier="c-create"
      >
        <:trigger>
          <div class="c-create-icon"></div>
        </:trigger>
        <:content as |args|>
          {{! template-lint-disable no-invalid-interactive }}
          <div class="c-create-menu" {{on "click" args.close}}>
            New Topic
          </div>
        </:content>
      </DMenu>
    </li>
  </template>);
});