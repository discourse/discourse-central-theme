import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";

export default class HeaderMessage extends Component {
  @service currentUser;
  @tracked isActive = false;

  @tracked inboxes = [];
  @tracked allUnread = 0;
  @tracked loading = true;

  @tracked selectedTabIndex = 0;
  clickOutsideListener = null;

  constructor() {
    super(...arguments);

    // fetch group inboxes
    const groupInboxes = ajax(
      "/u/" + this.currentUser.username + "/messages.json"
    ).then((data) => {
      return Promise.all(
        data.user.groups
          .filter((inbox) => inbox.has_messages)
          .map((inbox) => {
            return ajax(
              "/topics/private-messages-group/" +
                this.currentUser.username +
                "/" +
                inbox.name +
                ".json"
            ).then((messages) => {
              return { ...inbox, ...messages };
            });
          })
      );
    });

    // fetch personal inbox
    const myInbox = ajax(
      "/topics/private-messages/" + this.currentUser.username + ".json"
    ).then((messages) => {
      return [{ full_name: "My Inbox", ...messages }];
    });

    // console.log(groupInboxes, myInbox);

    // combine inboxes after all data is retrieved
    Promise.all([myInbox, groupInboxes]).then((data) => {
      // combine arrays
      const inboxes = data.flat();
      // console.log(inboxes);

      inboxes.forEach((inbox) => {
        // initialize unread total for the specific inbox
        inbox.unread_total = 0;
        inbox.topic_list.topics.forEach((topic) => {
          topic.posters.forEach((poster) => {
            // match the poster ID to the user ID and merge the users array
            const matchingUser = inbox.users.find(
              (user) => user.id === poster.user_id
            );
            if (matchingUser) {
              Object.assign(poster, matchingUser);
            }
          });

          // identify first and last posters for the topic
          topic.first_poster = topic.posters[0];
          topic.last_poster = topic.posters[topic.posters.length - 1];

          // check if topic is unreplied
          topic.no_replies =
            topic.participants.length === 1 && topic.posters.length === 1;

          // count unread posts for the specific topic
          if (Number.isInteger(topic.unread_posts) && topic.unread_posts > 0) {
            // increment unread count for the specific inbox
            inbox.unread_total++;
            topic.unread = 1; // mark this topic as unread
          } else {
            topic.unread = 0;
          }

          // create 'assigned' array'
          // let assigned = {};
          // let startIndex = 0;

          // if (topic.assigned_to_user) {
          //   assigned[startIndex++] = { ...topic.assigned_to_user };
          // }

          // if (topic.indirectly_assigned_to) {
          //   Object.values(topic.indirectly_assigned_to).forEach((assignee) => {
          //     assigned[startIndex++] = { ...assignee.assigned_to };
          //   });
          // }

          // topic.assigned = Object.keys(assigned).length > 0 ? assigned : null;
        });

        // update the total count of unread topics across all inboxes
        this.allUnread += inbox.unread_total;
      });

      this.inboxes = inboxes; // set inboxes
      this.loading = false; // turn off the loading indicator

      console.log(this.inboxes);
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
