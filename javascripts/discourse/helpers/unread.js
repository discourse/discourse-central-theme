import { registerUnbound } from "discourse-common/lib/helpers"

registerUnbound("isUnread", function (a) {
  return a > 0
})

registerUnbound("eq", (a, b) => {
  return a == b ? true : false
})
