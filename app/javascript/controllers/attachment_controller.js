import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="attachment"
export default class extends Controller {
  connect() {

  }

  remove() {
    this.element.remove()
  }
}
