import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { inject as service } from "@ember/service"
import { action } from "@ember/object"
import { ajax } from "discourse/lib/ajax"

export default class HeaderMessage extends Component {
  @service currentUser
  @tracked isActive = false
  @tracked groups = []
  @tracked myInbox = []
  @tracked selectedTabIndex = 0
  @tracked loading = true
  @tracked totalUnread = 0
  clickOutsideListener = null

  constructor() {
    super(...arguments)

    ajax("/u/" + this.currentUser.username + "/messages.json")
      .then((data) => {
        const groupPromises = data.user.groups
          .filter((group) => group.has_messages)
          .map((group) => {
            return ajax(
              "/topics/private-messages-group/" +
                this.currentUser.username +
                "/" +
                group.name +
                ".json"
            ).then((messagesData) => {
              const messagesData.users 
              const topicsWithUnreadCount = messagesData.topic_list.topics.map(
                (topic) => {
                  return {
                    ...topic,
                    unread_total:
                      topic.unread_posts && topic.unread_posts > 0 ? 1 : 0,
                  }
                }
              )

              const unreadTotal = topicsWithUnreadCount.reduce(
                (total, topic) => total + topic.unread_total,
                0
              )

              return {
                ...group,
                messages: topicsWithUnreadCount,
                unread_total: unreadTotal,
              }
            })
          })

        const userInboxPromise = ajax(
          "/topics/private-messages/" + this.currentUser.username + ".json"
        ).then((data) => {
          const topicsWithUnreadCount = data.topic_list.topics.map((topic) => {
            return {
              ...topic,
              unread_total:
                topic.unread_posts && topic.unread_posts > 0 ? 1 : 0,
            }
          })

          const unreadTotal = topicsWithUnreadCount.reduce(
            (total, topic) => total + topic.unread_total,
            0
          )

          return {
            messages: topicsWithUnreadCount,
            full_name: "My Inbox",
            unread_total: unreadTotal,
          }
        })

        return Promise.all([userInboxPromise, ...groupPromises])
      })
      .then((combinedData) => {
        this.groups = combinedData

        console.log(this.groups)

        this.groups.forEach((e) => {
          this.totalUnread += e.unread_total
        })

        this.loading = false
      })
      .catch((error) => {
        console.error("Error fetching data:", error)
        this.loading = false
      })
  }

  @action
  selectTab(index) {
    this.selectedTabIndex = index
  }

  @action
  toggleDropdown() {
    this.isActive = !this.isActive
    if (this.isActive) {
      this.clickOutsideListener = this.handleDocumentClick.bind(this)
      document.addEventListener("click", this.clickOutsideListener)
    } else {
      document.removeEventListener("click", this.clickOutsideListener)
    }
  }

  isClickOutsideMenu(target) {
    const menuElement = document.querySelector(".header-message__menu")
    return menuElement && !menuElement.contains(target)
  }

  handleDocumentClick(event) {
    const dropdownButton = document.querySelector(
      "button.header-message__button"
    )
    if (
      dropdownButton &&
      !dropdownButton.contains(event.target) &&
      this.isClickOutsideMenu(event.target)
    ) {
      this.toggleDropdown()
    }
  }
}
