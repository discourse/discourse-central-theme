import { apiInitializer } from "discourse/lib/api"

export default apiInitializer("0.11.1", (api) => {
  api.onPageChange(() => {
    const posts = document.querySelectorAll(".onscreen-post .row")

    if (posts) {
      posts.forEach((post) => {
        const avatar = post.querySelector(".post-avatar")
        const title = post.querySelector(".user-title")

        if (title !== null) {
          avatar.append(title)
        }
      })
    }
  })
})
