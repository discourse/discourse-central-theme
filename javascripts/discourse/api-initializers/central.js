import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("0.11.1", (api) => {
  api.onPageChange(() => {
    // hacky way to modify list title
    const listTitle = document.querySelector(
      '.select-kit-selected-name[data-name="all categories"] span.name',
    );
    if (listTitle !== null) {
      listTitle.innerHTML = document.querySelector(
        ".sidebar-left__link .active",
      )?.innerHTML;
    }
  });
});
