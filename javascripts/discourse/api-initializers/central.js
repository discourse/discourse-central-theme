import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("0.11.1", (api) => {
  api.onPageChange(() => {
    const button = document.querySelector("button.sidebar-left__toggle");
    button.addEventListener("click", () => {
      document.documentElement.classList.toggle("sidebar-left--open");
    });
    const activePage = window.location.href;
    const homePage = window.origin + "/";
    const latestPage = window.origin + "/latest";

    document.querySelectorAll(".sidebar-left__link > a").forEach((link) => {
      link.classList.remove("active");
      if (
        link.href !== homePage &&
        link.href !== latestPage &&
        activePage !== homePage &&
        activePage !== latestPage &&
        activePage.includes(link.href)
      ) {
        link.classList.add("active");
      } else if (link.href === activePage) {
        link.classList.add("active");
      }
    });

    // hacky way to modify list title

    const listTitle = document.querySelector(
      '.select-kit-selected-name[data-name="all categories"] span.name'
    );
    if (listTitle !== null) {
      listTitle.innerHTML = document.querySelector(
        ".sidebar-left__link .active"
      ).innerHTML;
    }
  });
});
