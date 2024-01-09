import { tracked } from "@glimmer/tracking";
import Service from "@ember/service";

export default class CustomSidebarState extends Service {
  @tracked isVisible = false;

  setTo(value) {
    this.isVisible = value;
  }
}
