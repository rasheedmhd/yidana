import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slim-select"
export default class extends Controller {
  static values = {
    placeholder: String,
    allowDeselect: Boolean,
  }

  connect() {
    this.slimSelect = new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: this.placeholderValue,
        allowDeselect: this.allowDeselectValue,
      }
    })
  }

  disconnect() {
    this.slimSelect.destroy()
    this.slimSelect = null
  }
}
