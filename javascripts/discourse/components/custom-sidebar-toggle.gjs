import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import DButton from "discourse/components/d-button";
import bodyClass from "discourse/helpers/body-class";

export default class CustomSidebarToggle extends Component {
  @service customSidebarState;

  @action
  toggleCustomSidebar() {
    this.customSidebarState.setTo(!this.customSidebarState.isVisible);
  }

  get buttonIcon() {
    return this.customSidebarState.isVisible ? "times" : "bars";
  }

  <template>
    {{#if this.customSidebarState.isVisible}}
      {{bodyClass "sidebar-left--open"}}
    {{/if}}
    <DButton
      @icon={{this.buttonIcon}}
      @action={{this.toggleCustomSidebar}}
      @class="sidebar-left__toggle"
    />
  </template>
}
