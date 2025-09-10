import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "tag", "hiddenField" ]

  connect() {
    this.updateTagsFromHiddenField()
  }

  toggleTag(event) {
    event.preventDefault()
    const button = event.target.closest("button")
    if (button) {
      button.classList.toggle("active-tag")
      this.updateHiddenField()
    }
  }

  updateHiddenField() {
    const activeTags = this.tagTargets.filter(tag => tag.classList.contains("active-tag"))
    const selectedValues = activeTags.map(tag => tag.dataset.value)
    this.hiddenFieldTarget.value = selectedValues.join(', ')
  }

  updateTagsFromHiddenField() {
    const existingOptions = this.hiddenFieldTarget.value.split(',').map(s => s.trim());
    this.tagTargets.forEach(tag => {
      if (existingOptions.includes(tag.dataset.value)) {
        tag.classList.add("active-tag")
      } else {
        tag.classList.remove("active-tag")
      }
    });
  }
}