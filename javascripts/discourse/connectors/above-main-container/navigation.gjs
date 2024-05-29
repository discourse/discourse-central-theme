import Component from "@glimmer/component";
import { service } from "@ember/service";
// import bodyClass from "discourse/helpers/body-class";

export default class Navigation extends Component {
  @service currentUser;
  @service router;

  <template>
    <div class="navigation">

      <nav>
        <ul>
          <li>
            <a href="/" class="home">
              <span>
                Home
              </span>
            </a>
          </li>

          <li>
            <a href="/" class="home">
              <span>
                Topics
              </span>
            </a>
          </li>

          <li>
            <a href="/" class="home">
              <span>
                Categories
              </span>
            </a>
          </li>

          {{#if this.currentUser}}{{/if}}
        </ul>
      </nav>

      <footer>
      </footer>

    </div>
  </template>
}
