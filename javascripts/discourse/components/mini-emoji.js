// app/components/mini-emoji.js
import Component from "@glimmer/component";

const emojis = ["😀", "😍", "🚀", "🌈", "🎉", "🍕", "🐱", "🌍", "🎸", "📚"];

export default class MiniEmoji extends Component {
  get miniEmoji() {
    const randomIndex = Math.floor(Math.random() * emojis.length);
    return emojis[randomIndex];
  }

  async handleClick() {
    const emoji = this.miniEmoji;

    try {
      await navigator.clipboard.writeText(emoji);
      // You can add a visual indication that the emoji is copied, e.g., by changing the color
    } catch (err) {
      // eslint-disable-next-line no-console
      console.error("Unable to copy text to clipboard", err);
    }
  }
}
