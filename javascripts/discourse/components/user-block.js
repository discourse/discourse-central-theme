import Component from "@glimmer/component"
import { ajax } from "discourse/lib/ajax"
import User from "discourse/models/user"
import { tracked } from "@glimmer/tracking"

export default class UserBlock extends Component {
  @tracked banner = null
  @tracked bio = null
  @tracked website = null
  @tracked website_name = null
  @tracked currentUser = null

  constructor() {
    super(...arguments)

    this.currentUser = User.current()

    if (this.currentUser !== null) {
      const currentUserUrl = "/u/" + this.currentUser.username + ".json"

      ajax(currentUserUrl).then((data) => {
        this.updateUserData(data.user)
      })
    }
  }

  updateUserData(user) {
    this.banner = user.profile_background_upload_url
    this.bio = user.bio_excerpt
    this.website = user.website
    this.website_name = user.website_name
  }

  willDestroy() {
    this.currentUser = null
    this.banner = null
    this.bio = null
    this.website = null
    this.website_name = null
  }
}
