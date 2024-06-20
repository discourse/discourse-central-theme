import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";

export default class StickySidebar extends Component {
  @tracked top = 0;
  @tracked bottom = 0;
  @tracked position = "relative";

  offset = 0;
  prevScrollTop = 0;
  yOrigin = 0;
  mode = "unset";

  @action
  onScroll() {
    const scrollY = window.scrollY;
    const scrollingUp = scrollY < this.prevScrollTop;
    const scrollingDown = scrollY > this.prevScrollTop;
    const element = this.element;
    if (!this.yOrigin) {
      // save the initial vertical position
      this.yOrigin = getYOrigin(this.element);
    }
    const stickyTop = this.yOrigin;

    if (scrollingUp) {
      if (isTopInView(element, this.yOrigin)) {
        this.mode = "top";
        this.position = "fixed";
        this.top = stickyTop;
        this.bottom = "unset";
      }
      if (this.mode === "bottom") {
        this.mode = "between";
        const top = element.getBoundingClientRect().top;
        this.position = "relative";
        this.top = top + scrollY - this.yOrigin;
      }
    } else if (scrollingDown) {
      if (isBottomInView(element, this.yOrigin)) {
        this.mode = "bottom";
        this.position = "fixed";
        this.bottom = 0;
        this.top = "unset";
      }
      if (this.mode === "top") {
        this.mode = "between";
        const top = element.getBoundingClientRect().top;
        this.position = "relative";
        this.top = top + scrollY - this.yOrigin;
      }
    }
    this.prevScrollTop = scrollY;
  }

  @action
  didInsert(element) {
    this.element = element;
    this.offset = this.element.offsetTop;
  }
}

function isTopInView(element, yOffset) {
  const rect = element.getBoundingClientRect();
  return rect.top >= yOffset && rect.top <= window.innerHeight;
}

function isBottomInView(element) {
  const rect = element.getBoundingClientRect();
  return rect.bottom >= 0 && rect.bottom <= window.innerHeight;
}

function getYOrigin(el) {
  const rect = el.getBoundingClientRect();
  const scrollTop = window.scrollY || window.pageYOffset;
  return rect.top + scrollTop;
}
