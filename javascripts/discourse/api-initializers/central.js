import { apiInitializer } from "discourse/lib/api"

export default apiInitializer("0.11.1", (api) => {
  api.onPageChange(() => {
    const activePage = window.location.href
    const homePage = window.origin + "/"
    const links = document
      .querySelectorAll(".sidebar-left__link a")
      .forEach((link) => {
        link.classList.remove("active")
        if (
          link.href !== homePage &&
          activePage !== homePage &&
          activePage.includes(link.href)
        ) {
          link.classList.add("active")
        } else if (link.href == activePage) {
          link.classList.add("active")
        }
      })
  })
})
