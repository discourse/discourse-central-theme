import { modifier } from "ember-modifier";

export default modifier((element, [callback]) => {
  const handleScroll = () => callback();

  window.addEventListener("scroll", handleScroll);

  return () => {
    window.removeEventListener("scroll", handleScroll);
  };
});
