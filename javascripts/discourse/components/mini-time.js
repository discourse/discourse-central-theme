import Component from "@glimmer/component";

export default class MiniTime extends Component {
  get miniTime() {
    const now = new Date();
    let hours = now.getHours();
    const minutes = now.getMinutes().toString().padStart(2, "0");

    // Determine AM or PM
    const amPm = hours >= 12 ? "p" : "a";

    // Convert to 12-hour format
    hours = hours % 12 || 12;

    return `${hours}:${minutes}${amPm}`;
  }
}
