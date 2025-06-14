import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import NavItem from "discourse/components/nav-item";
import PluginOutlet from "discourse/components/plugin-outlet";

@classNames("above-main-container-outlet", "ssadmin")
export default class Ssadmin extends Component {
  <template>
    {{#if this.currentUser.admin}}
      <div class="--temp admin-main-nav">
        <ul class="nav nav-pills">
          {{#if this.currentUser.admin}}
            <NavItem @route="admin.dashboard" @label="admin.dashboard.title" />
            <NavItem
              @route="adminSiteSettings"
              @label="admin.site_settings.title"
            />
            <NavItem @route="adminUsers" @label="admin.users.title" />
          {{/if}}
          {{#if this.showGroups}}
            <NavItem @route="groups" @label="admin.groups.title" />
          {{/if}}
          {{#if this.showBadges}}
            <NavItem @route="adminBadges" @label="admin.badges.title" />
          {{/if}}
          {{#if this.currentUser.admin}}
            <NavItem @route="adminEmail" @label="admin.email.title" />
            <NavItem @route="adminLogs" @label="admin.logs.title" />
            <NavItem
              @route="adminCustomizeThemes"
              @routeParam="themes"
              @label="admin.customize.title"
            />
            <NavItem @route="adminApi" @label="admin.api.title" />
            {{#if this.siteSettings.enable_backups}}
              <NavItem @route="admin.backups" @label="admin.backups.title" />
            {{/if}}
            <NavItem @route="adminPlugins" @label="admin.plugins.title" />
          {{/if}}
          <PluginOutlet @name="admin-menu" />
        </ul>
      </div>
    {{/if}}
  </template>
}
