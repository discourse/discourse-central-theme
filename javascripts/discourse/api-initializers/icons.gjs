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

  if (currentUser) {
    api.headerIcons.add("c-user", <template>
      <li class="c-user">
        <DMenu
          @placement="bottom-end"
          @modalForMobile={{true}}
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
                    {{i18n (themePrefix "user.view_your_profile")}}
                  </span>
                </div>
              </LinkTo>
              <ul class="c-user-menu__links">
                <li>
                  <LinkTo
                    data-name="messages"
                    @route="userPrivateMessages"
                    @model={{currentUser}}
                  >
                    <span>
                      {{i18n "js.user.private_messages"}}
                    </span>
                  </LinkTo>
                </li>

                <li>
                  <LinkTo
                    @route="userActivity.bookmarks"
                    @model={{currentUser}}
                    data-name="bookmarks"
                  >
                    <span>
                      {{i18n "js.user.bookmarks"}}
                    </span>
                  </LinkTo>
                </li>

                <li>
                  <LinkTo
                    data-name="invites"
                    @route="userInvited"
                    @model={{currentUser}}
                  >
                    <span>
                      {{i18n "js.user.invited.title"}}
                    </span>
                  </LinkTo>
                </li>

                <li>
                  <LinkTo
                    data-name="preferences"
                    @route="preferences"
                    @model={{currentUser}}
                  >
                    <span>
                      {{i18n "user.preferences.title"}}
                    </span>
                  </LinkTo>
                </li>
                <li>
                  <a
                    data-name="logout"
                    role="button"
                    onclick={{routeAction "logout"}}
                  >
                    <span>
                      {{i18n "user.log_out"}}
                    </span>
                  </a>
                </li>
              </ul>
              {{#if (or currentUser.moderator currentUser.admin)}}
                <ul class="c-user-menu__links">
                  <li>
                    <LinkTo data-name="flagged" @route="review.index">
                      <span>Flagged
                        {{#unless (eq currentUser.reviewable_count 0)}}
                          ({{currentUser.reviewable_count}})
                        {{/unless}}
                      </span>
                    </LinkTo>
                  </li>

                  <li>
                    <LinkTo data-name="groups" @route="groups.index">
                      <span>
                        {{i18n "js.groups.index.title"}}
                      </span>
                    </LinkTo>
                  </li>

                  <li>
                    <LinkTo data-name="admin" @route="admin.dashboard.general">
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
            <div class="c-create__icon"></div>
          </:trigger>
          <:content as |args|>
            {{! template-lint-disable no-invalid-interactive }}
            <ul class="c-create__menu" {{on "click" args.close}}>
              <li>
                <LinkTo @route="new-topic">
                  <span>{{i18n "js.topic.create"}}</span>
                </LinkTo>
              </li>
              <li>
                <LinkTo @route="new-message">
                  <span>{{i18n "js.user.new_private_message"}}</span>
                </LinkTo>
              </li>
              <li>
                <LinkTo @route="userActivity.drafts" @model={{currentUser}}>
                  <span>{{i18n "js.drafts.label"}}</span>
                </LinkTo>
              </li>
            </ul>
          </:content>
        </DMenu>
      </li>
    </template>);
  }
});
