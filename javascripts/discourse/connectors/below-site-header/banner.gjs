import Component from "@glimmer/component";
import DiscourseBanner from "discourse/components/discourse-banner";

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Banner extends Component {
  // moves banner topic from main-outlet to below-site-header
  <template>
    <DiscourseBanner />
  </template>
}
