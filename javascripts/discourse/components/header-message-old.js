import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";

export default class HeaderMessage extends Component {
  @service currentUser;
  @tracked isActive = false;
  @tracked groups = [];
  @tracked selectedTabIndex = 0;
  @tracked loading = true;
  @tracked totalUnread = 0;
  clickOutsideListener = null;

  constructor() {
    super(...arguments);

    ajax("/u/" + this.currentUser.username + "/messages.json")
      .then((data) => {
        // list user groups
        const groupPromises = data.user.groups
          // but keep only the groups with inboxes
          .filter((group) => group.has_messages)
          // load each group inbox
          .map((group) => {
            return ajax(
              "/topics/private-messages-group/" +
                this.currentUser.username +
                "/" +
                group.name +
                ".json"
            ).then((pmGroupData) => {
              // match poster id to users id and merge the users array
              pmGroupData.topic_list.topics.forEach((topic) => {
                topic.posters.forEach((poster) => {
                  const matchingUser = pmGroupData.users.find(
                    (user) => user.id === poster.user_id
                  );
                  if (matchingUser) {
                    Object.assign(poster, matchingUser);
                  }
                });

                topic.first_poster = topic.posters[0];
                topic.last_poster = topic.posters[topic.posters.length - 1];
                topic.no_replies =
                  topic.participants.length === 1 && topic.posters.length === 1
                    ? true
                    : false;
              });

              // if topic has unread posts, mark topic has unread
              const unreadTopics = pmGroupData.topic_list.topics.map(
                (topic) => {
                  return {
                    ...topic,
                    unread_total:
                      topic.unread_posts && topic.unread_posts > 0 ? 1 : 0,
                  };
                }
              );

              // total count of unread topics
              const unreadTotal = unreadTopics.reduce(
                (total, topic) => total + topic.unread_total,
                0
              );

              return {
                ...group,
                messages: unreadTopics,
                unread_total: unreadTotal,
              };
            });
          });

        // get user personal inbox and do the same things... can this be consolidated?
        const userInboxPromise = ajax(
          "/topics/private-messages/" + this.currentUser.username + ".json"
        ).then((pmData) => {
          pmData.topic_list.topics.forEach((topic) => {
            topic.posters.forEach((poster) => {
              const matchingUser = pmData.users.find(
                (user) => user.id === poster.user_id
              );
              if (matchingUser) {
                Object.assign(poster, matchingUser);
              }
            });
            topic.first_poster = topic.posters[0];
            topic.last_poster = topic.posters[topic.posters.length - 1];
            topic.no_replies =
              topic.participants.length === 1 && topic.posters.length === 1
                ? true
                : false;
          });

          const unreadTopics = pmData.topic_list.topics.map((topic) => {
            return {
              ...topic,
              unread_total:
                topic.unread_posts && topic.unread_posts > 0 ? 1 : 0,
            };
          });
          const unreadTotal = unreadTopics.reduce(
            (total, topic) => total + topic.unread_total,
            0
          );

          return {
            messages: unreadTopics,
            full_name: "My Inbox",
            unread_total: unreadTotal,
          };
        });

        return Promise.all([userInboxPromise, ...groupPromises]);
      })
      .then((combinedData) => {
        this.groups = combinedData;

        // all unread topics count
        this.groups.forEach((e) => {
          this.totalUnread += e.unread_total;
        });

        // turn off loading spinner
        this.loading = false;
      })
      .catch((error) => {
        // eslint-disable-next-line no-console
        console.error("Error fetching data:", error);
        this.loading = false;
      });
  }

  @action
  selectTab(index) {
    this.selectedTabIndex = index;
  }

  @action
  toggleDropdown() {
    this.isActive = !this.isActive;
    if (this.isActive) {
      this.clickOutsideListener = this.handleDocumentClick.bind(this);
      document.addEventListener("click", this.clickOutsideListener);
    } else {
      document.removeEventListener("click", this.clickOutsideListener);
    }
  }

  isClickOutsideMenu(target) {
    const menuElement = document.querySelector(".header-message__menu");
    return menuElement && !menuElement.contains(target);
  }

  handleDocumentClick(event) {
    const dropdownButton = document.querySelector(
      "button.header-message__button"
    );
    if (
      dropdownButton &&
      !dropdownButton.contains(event.target) &&
      this.isClickOutsideMenu(event.target)
    ) {
      this.toggleDropdown();
    }
  }
}
