import Component from "@glimmer/component";
import { ajax } from "discourse/lib/ajax";
import { tracked } from "@glimmer/tracking";

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
    this.randomBirthday = null;
  }

  get miniEmoji() {
    const randomIndex = Math.floor(Math.random() * emojis.length);
    return emojis[randomIndex];
  }
}
