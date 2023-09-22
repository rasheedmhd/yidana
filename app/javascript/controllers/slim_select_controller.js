import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slim-select"
export default class extends Controller {
  static values = {
    placeholder: String,
    allowDeselect: Boolean,
    closeOnSelect: { type: Boolean, default: true },
  }

  connect() {
    this.slimSelect = new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: this.placeholderValue,
        allowDeselect: this.allowDeselectValue,
        closeOnSelect: this.closeOnSelectValue,
      }
    })
  }

  disconnect() {
    this.slimSelect.destroy()
    this.slimSelect = null
  }
}
