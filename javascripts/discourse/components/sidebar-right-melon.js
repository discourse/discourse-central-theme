import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"

export default class SidebarRightMelon extends Component {
  @tracked melon = null
  API_TOKEN = "apify_api_eh6HzOW5Qp9KUKeeyNC4gN8AcznlUI4b5cNA"

  constructor() {
    super(...arguments)
    this.fetchMelonData()
  }

  async fetchMelonData() {
    const response = await fetch(
      `https://api.apify.com/v2/acts/apify~web-scraper/runs/last/dataset/items?token=${this.API_TOKEN}`
    )
    const data = await response.json()
    this.melon = data
  }

  willDestroy() {
    this.melon = null
  }
}
