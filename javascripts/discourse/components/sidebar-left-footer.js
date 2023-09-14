import Component from "@glimmer/component"

export default class SidebarLeftFooter extends Component {
  get footerLinks() {
    return JSON.parse(settings.sidebar_left_footer_links)
  }
}
