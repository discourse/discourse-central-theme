import Component from "@glimmer/component"

export default class Footer extends Component {
  get footerLinks() {
    return JSON.parse(settings.sidebar_left_footer_links)
  }
}
