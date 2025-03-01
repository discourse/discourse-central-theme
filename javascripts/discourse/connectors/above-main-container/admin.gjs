import Component from "@glimmer/component";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { i18n } from "discourse-i18n";

export default class CentralAdmin extends Component {
  @service currentUser;
  @service router;
  @service siteSettings;

  get isAdmin() {
    return this.router.currentRouteName.startsWith("admin");
  }

  <template>
    {{#if this.isAdmin}}
      <ul class="nav nav-pills">
        {{#if this.currentUser.admin}}
          <li>
            <LinkTo @route="admin.dashboard">
              <span>{{i18n "admin.dashboard.title"}}</span>
            </LinkTo>
          </li>
          <li>
            <LinkTo @route="adminSiteSettings">
              <span>{{i18n "admin.site_settings.title"}}</span>
            </LinkTo>
          </li>
          <li>
            <LinkTo @route="adminUsers">
              <span>{{i18n "admin.users.title"}}</span>
            </LinkTo>
          </li>
        {{/if}}
        {{#if this.showGroups}}
          <li>
            <LinkTo @route="groups">
              <span>{{i18n "admin.groups.title"}}</span>
            </LinkTo>
          </li>
        {{/if}}
        {{#if this.showBadges}}
          <li>
            <LinkTo @route="adminBadges">
              <span>{{i18n "admin.badges.title"}}</span>
            </LinkTo>
          </li>
        {{/if}}
        {{#if this.currentUser.admin}}
          <li>
            <LinkTo @route="adminEmail">
              <span>{{i18n "admin.email.title"}}</span>
            </LinkTo>
          </li>
          <li>
            <LinkTo @route="adminLogs">
              <span>{{i18n "admin.logs.title"}}</span>
            </LinkTo>
          </li>
          <li>
            <LinkTo @route="adminCustomizeThemes" @model="themes">
              <span>{{i18n "admin.customize.title"}}</span>
            </LinkTo>
          </li>
          <li>
            <LinkTo @route="adminApi">
              <span>{{i18n "admin.api.title"}}</span>
            </LinkTo>
          </li>
          {{#if this.siteSettings.enable_backups}}
            <li>
              <LinkTo @route="admin.backups">
                <span>{{i18n "admin.backups.title"}}</span>
              </LinkTo>
            </li>
          {{/if}}
          <li>
            <LinkTo @route="adminPlugins">
              <span>{{i18n "admin.plugins.title"}}</span>
            </LinkTo>
          </li>
        {{/if}}
      </ul>

    {{/if}}
  </template>
}
