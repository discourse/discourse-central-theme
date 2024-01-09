import Service from "@ember/service";
import { tracked } from "@glimmer/tracking";

export default class CustomSidebarState extends Service {
  @tracked isVisible = false;

  setTo(value) {
    this.isVisible = value;
  }
}
