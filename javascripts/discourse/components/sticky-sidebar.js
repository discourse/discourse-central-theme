import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";

export default class StickySidebar extends Component {
  @tracked top = 0;
  @tracked position = 'relative';

  offset = 0;
  prevScrollTop = 0;

  constructor() {
    super(...arguments);
    this.offset = 0;
  }

  @action
  onScroll() {
    const scrollY = window.scrollY;
    const scrollingUp = scrollY < this.prevScrollTop;
    const scrollingDown = scrollY > this.prevScrollTop;
    const element = this.element;
    const topDist = element.offsetTop;
    const stickyTop = 104;
    const stickyBot = window.innerHeight - element.getBoundingClientRect().height + 104;

    if (scrollingUp) {
      if (isTopInView(element)) {
        this.position = 'sticky';
        this.top = stickyTop;
      } else if (isBottomInView(element)) {
        this.position = 'relative';
        this.top = topDist - this.offset;
      }
    } else if (scrollingDown) {
      if (isTopInView(element)) {
        this.position = 'relative';
        this.top = topDist - this.offset;
      } else if (isBottomInView(element)) {
        this.position = 'sticky';
        this.top = stickyBot - 208;
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

function isTopInView(element) {
  const rect = element.getBoundingClientRect();
  return rect.top >= 104 && rect.top <= window.innerHeight;
}

function isBottomInView(element) {
  const rect = element.getBoundingClientRect();
  return rect.bottom >= 0 && rect.bottom+104 <= window.innerHeight;
}

