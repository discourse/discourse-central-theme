import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";

const emojis = ["🥳", "🤩", "🎂", "🎉", "🎊", "🎁", "🎈"];

export default class MiniBirthday extends Component {
  @tracked randomBirthday = null;
  @tracked randomEmoji = emojis[Math.floor(Math.random() * emojis.length)];

  constructor() {
    super(...arguments);

    ajax("/cakeday/birthdays/today.json").then((data) => {
      const birthdays = data.birthdays;
      this.randomBirthday =
        birthdays[Math.floor(Math.random() * birthdays.length)];
    });
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.randomBirthday = null;
  }

  get miniEmoji() {
    const randomIndex = Math.floor(Math.random() * emojis.length);
    return emojis[randomIndex];
  }
}
