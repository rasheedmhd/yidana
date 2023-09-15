import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toasts"
export default class extends Controller {
  connect() {
    const elList = document.querySelectorAll('.toast')
    const list = [...elList].map(el => new bootstrap.Toast(el, { delay: 5000 }))
    list.map(el => el.show())
  }
}
