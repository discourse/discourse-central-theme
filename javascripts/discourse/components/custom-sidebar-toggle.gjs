import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { inject as service } from '@ember/service';
import DButton from "discourse/components/d-button";
import { concat, fn, hash } from "@ember/helper";
import bodyClass from "discourse/helpers/body-class";

export default class CustomSidebarToggle extends Component {
  @service customSidebarState; 

  @action
  toggleCustomSidebar() {
      this.customSidebarState.setTo(!this.customSidebarState.isVisible)
  }

  get buttonIcon() {
    return this.customSidebarState.isVisible ? "times" : "bars"
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
