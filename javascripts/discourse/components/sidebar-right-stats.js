import Component from "@glimmer/component"
import { ajax } from "discourse/lib/ajax"
import { tracked } from "@glimmer/tracking"

export default class SidebarRightStats extends Component {
  @tracked stats = null
  @tracked total = null

  constructor() {
    super(...arguments)

    ajax("/directory_items.json?period=all").then((data) => {
      let result = data.meta.total_rows_directory_items
      this.total = result
    })
  }

  willDestroy() {
    this.total = null
  }
}
