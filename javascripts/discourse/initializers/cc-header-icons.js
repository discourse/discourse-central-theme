import { withPluginApi } from "discourse/lib/plugin-api";
import { h } from "virtual-dom";
import { iconNode } from "discourse-common/lib/icon-library";

export default {
  initialize() {
    withPluginApi("0.8", (api) => {
      api.decorateWidget("home-logo:before", (helper) => {
        return helper.h("button.sidebar-left__toggle", [
          iconNode("bars"),
          iconNode("m-close"),
        ]);
      });

      api.reopenWidget("header-notifications", {
        html(attrs) {
          const { user } = attrs;

          let avatarAttrs = {
            template: user.get("avatar_template"),
            username: user.get("username"),
          };

          if (this.siteSettings.enable_names) {
            avatarAttrs.name = user.get("name");
          }

          const contents = [h("div", iconNode("bell"))];

          if (this.currentUser.status) {
            contents.push(
              this.attach("user-status-bubble", this.currentUser.status)
            );
          }

          if (user.isInDoNotDisturb()) {
            contents.push(h("div.do-not-disturb-background", iconNode("moon")));
          } else {
            if (user.new_personal_messages_notifications_count) {
              contents.push(
                this.attach("link", {
                  action: attrs.action,
                  className: "badge-notification with-icon new-pms",
                  icon: "envelope",
                  omitSpan: true,
                  title: "notifications.tooltip.new_message_notification",
                  titleOptions: {
                    count: user.new_personal_messages_notifications_count,
                  },
                  attributes: {
                    "aria-label": I18n.t(
                      "notifications.tooltip.new_message_notification",
                      {
                        count: user.new_personal_messages_notifications_count,
                      }
                    ),
                  },
                })
              );
            } else if (user.unseen_reviewable_count) {
              contents.push(
                this.attach("link", {
                  action: attrs.action,
                  className: "badge-notification with-icon new-reviewables",
                  icon: "flag",
                  omitSpan: true,
                  title: "notifications.tooltip.new_reviewable",
                  titleOptions: { count: user.unseen_reviewable_count },
                  attributes: {
                    "aria-label": I18n.t(
                      "notifications.tooltip.new_reviewable",
                      {
                        count: user.unseen_reviewable_count,
                      }
                    ),
                  },
                })
              );
            } else if (user.all_unread_notifications_count) {
              contents.push(
                this.attach("link", {
                  action: attrs.action,
                  className: "badge-notification unread-notifications",
                  rawLabel: user.all_unread_notifications_count,
                  omitSpan: true,
                  title: "notifications.tooltip.regular",
                  titleOptions: { count: user.all_unread_notifications_count },
                  attributes: {
                    "aria-label": I18n.t("user.notifications"),
                  },
                })
              );
            }
          }
          return contents;
        },
      });
      api.addToHeaderIcons("header-user");
      api.addToHeaderIcons("header-message");
      api.replaceIcon("d-chat", "m-chat_bubble_outline");
      // api.addToHeaderIcons("header-create")
    });
  },
};
