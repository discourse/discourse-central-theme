import { concat } from "@ember/helper";
import concatClass from "discourse/helpers/concat-class";

const Cta = <template>
  <div
    class={{concatClass "block block-cta" (if @size (concat "block--" @size))}}
  >
    <h4>{{@title}}</h4>
    <p>{{@description}}</p>
    <a role="button" href={{@url}}><span>{{@cta}}</span></a>
  </div>
</template>;

export default Cta;
