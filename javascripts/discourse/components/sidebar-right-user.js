import Component from "@glimmer/component"
import { ajax } from "discourse/lib/ajax"
import { inject as service } from "@ember/service"
import { tracked } from "@glimmer/tracking"
import { action } from "@ember/object"

export default class SidebarRightUser extends Component {
  @service currentUser

  @tracked banner = null
  @tracked bio = null
  @tracked website = null
  @tracked website_name = null

  constructor() {
    super(...arguments)

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
}


