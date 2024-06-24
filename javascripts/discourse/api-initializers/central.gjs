import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.0", () => {
  let css = "";
  const categories = settings.category_icons;
  if (categories) {
    categories.forEach((category) => {
      const id = category.id[0];
      const emoji = category.emoji;

      css += `.badge-category__wrapper .badge-category[data-category-id="${id}"]:before { content: "${emoji}"; }\n`;
    });

    const styleElement = document.createElement("style");
    styleElement.type = "text/css";
    styleElement.appendChild(document.createTextNode(css));
    document.head.appendChild(styleElement);
  }
});
