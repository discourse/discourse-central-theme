import Component from "@ember/component"
import { action } from "@ember/object"
import discourseComputed from "discourse-common/utils/decorators"
import I18n from "I18n"

export default Component.extend({
  classNames: ["gc-navigation"],
  onNavigate: null,
  currentSelection: null,
  primaryGroupCategory: null,

  init() {
    this._super(...arguments)
    this.primaryGroupCategory = this._findPrimaryGroupCategory()

    if (this.primaryGroupCategory) {
      this._navigateTo(`category-${this.primaryGroupCategory.id}`, false)
    } else {
      if (this.siteSettings.home_feed_personalization_enabled) {
        this._navigateTo(this.activeFilter, false)
      } else {
        this._navigateTo("latest", false)
      }
    }
  },

  @action
  navItemChanged(navItemId) {
    this._navigateTo(navItemId, true)
  },

  @discourseComputed
  navItems() {
    const navItems = []

    const filters = settings.homepage_filters.split("|")
    filters.forEach((filter) => {
      navItems.push({
        id: filter,
        name: I18n.t(themePrefix(`navigation.${filter}`)),
      })
    })

    const filterCategories = this._calculateFilterCategories()
    filterCategories.forEach((filterCategory) => {
      const [categoryIdString, customLabel] = filterCategory.split(",")
      const categoryId = parseInt(categoryIdString, 10)
      const category = this._findCategory(categoryId)

      if (category) {
        navItems.push({
          id: `category-${category.id}`,
          name: customLabel || category.name,
        })
      }
    })

    return navItems
  },

  _calculateFilterCategories() {
    const filterCategories = settings.homepage_filter_categories.split("|")

    if (this.primaryGroupCategory) {
      filterCategories.unshift(
        `${this.primaryGroupCategory.id},${this.primaryGroupCategory.name}`
      )
    }

    return filterCategories
  },

  _findPrimaryGroupCategory() {
    const primaryGroupName = this.currentUser?.primary_group_name?.toLowerCase()

    if (primaryGroupName) {
      const groupCategories =
        settings.homepage_filter_group_categories.split("|")

      for (const groupCategory of groupCategories) {
        const [groupName, id, name] = groupCategory.split(",")

        if (primaryGroupName === groupName.toLowerCase() && id && name) {
          return { id, name }
        }
      }
    }

    return null
  },

  _findCategory(categoryId) {
    return this.site.categories.findBy("id", categoryId)
  },

  _navigateTo(navItemId, triggerEvent) {
    this.set("currentSelection", navItemId)

    const [filter, categoryIdString] = navItemId.split("-")
    let category = null

    if (filter === "category") {
      const categoryId = parseInt(categoryIdString, 10)
      category = this._findCategory(categoryId)
    }

    this.onNavigate(filter, category)

    if (triggerEvent) {
      this.appEvents.trigger(
        "enhanced_user_analytics:event",
        "homepage_filter_change",
        {
          filter,
          category_id: category ? category.id : null,
        },
        {
          clickRef: "homepage_filter",
        }
      )
    }
  },
})
