import Component from "@glimmer/component"
import { ajax } from "discourse/lib/ajax"
import { tracked } from "@glimmer/tracking"

export default class SidebarRightTopContributors extends Component {
  @tracked topContributors = null

  constructor() {
    super(...arguments)

    const count = this.args?.params?.count || 10

    ajax(`/directory_items.json?period=yearly&order=likes_received`).then(
      (data) => {
        this.topContributors = data.directory_items.slice(1, count + 1)
      }
    )
  }

  willDestroy() {
    this.topContributors = null
  }
}
