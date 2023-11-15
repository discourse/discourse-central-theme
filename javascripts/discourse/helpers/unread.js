import { registerUnbound } from "discourse-common/lib/helpers";

registerUnbound("eq", (a, b) => {
  return a == b ? true : false;
});

registerUnbound("last", function (array) {
  return array.length - 1;
});

registerUnbound("objectToArray", function (obj) {
  return Object.values(obj);
});
