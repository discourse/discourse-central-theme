import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";

export default class StickySidebar extends Component {
  @tracked top = 0;
  @tracked bottom = 0;
  @tracked position = "relative";

  headerHeight = 72;
  offset = 0;
  prevScrollTop = 0;
  yOrigin = 0;
  mode = "top";

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

    if (scrollingUp) {
      switch (this.mode) {
        case "between":
          if (isTopInView(element, this.headerHeight)) {
            this.mode = "pinned";
            this.position = "fixed";
            this.top = `${this.headerHeight}px`;
            this.bottom = "unset";
          }
          break;
        case "pinned":
          if (scrollY < this.yOrigin - this.headerHeight) {
            this.mode = "top";
            this.position = "relative";
            this.top = 0;
            this.bottom = "unset";
          }
          break;
        case "bottom":
          this.mode = "between";
          const top = element.getBoundingClientRect().top;
          this.position = "relative";
          this.top = top + scrollY - this.yOrigin + "px";
          break;
      }
    } else if (scrollingDown) {
      switch (this.mode) {
        case "between":
          if (isBottomInView(element, this.yOrigin)) {
            this.mode = "bottom";
            this.position = "fixed";
            this.bottom = 0;
            this.top = "unset";
          }
          break;
        case "pinned":
        case "top":
          this.mode = "between";
          const top = element.getBoundingClientRect().top;
          this.position = "relative";
          this.top = top + scrollY - this.yOrigin;
          break;
      }
    }
    this.prevScrollTop = scrollY;
  }

  @action
  didInsert(element) {
    this.element = element;
    this.offset = this.element.offsetTop;
    const headerElement = document.querySelector(".d-header");
    if (headerElement) {
      this.headerHeight = headerElement.offsetHeight;
    }
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
