import Component from "@glimmer/component"
import { ajax } from "discourse/lib/ajax"
import { tracked } from "@glimmer/tracking"

export default class Stats extends Component {
  @tracked stats = null
  @tracked total = null

  constructor() {
    super(...arguments)

    const url = "/admin/users/list/active.json"


    ajax("/directory_items.json?period=all").then((data) => {
      let result = data.meta.total_rows_directory_items
      this.total = result
    })

    let key1 = settings.apiKey


    fetch(url, {
      method: "GET",
      headers: {
        "Api-Key": key1,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        let results = []
        for (const item of data) {
          results.push(item["username"])
        }
        this.stats = results
      })
      .catch((error) => {
        console.log(error)
      })

    // ajax(url).then((data) => {
    //   let results = []
    //   for (const item of data) {
    //     results.push(item["username"])
    //   }
    //   this.stats = results
    // })
  }

  willDestroy() {
    this.stats = null
    this.total = null
  }
}
