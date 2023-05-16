import Component from "@glimmer/component"
import { ajax } from "discourse/lib/ajax"
import User from "discourse/models/user"
import { tracked } from "@glimmer/tracking"

export default class UserBlock extends Component {
  @tracked banner = null
  @tracked bio = null
  @tracked currentUser = null

  constructor() {
    super(...arguments)

    this.currentUser = User.current()

    if (this.currentUser !== null) {
      const currentUserUrl = "/u/" + this.currentUser.username + ".json"

      ajax(currentUserUrl).then((data) => {
        this.banner = data.user.profile_background_upload_url
        this.bio = data.user.bio_excerpt
      })
    }
  }

  // willDestroy() {
  //   this.userBlock = null
  // }
}
