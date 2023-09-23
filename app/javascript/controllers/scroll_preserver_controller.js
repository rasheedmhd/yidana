import { Controller } from "@hotwired/stimulus"


window.scrollPreserverCache = {}

// Connects to data-controller="scroll-preserver"
export default class extends Controller {
  static values = {
    id: String
  }

  connect() {
    this.id = this.idValue || this.element.id
    if (!this.id) throw Error("scroll-preserver requires an id")

    this._maybeRestoreScroll()
  }

  scrolled() {
    window.scrollPreserverCache[this.id] = {
      top: this.element.scrollTop,
      left: this.element.scrollLeft
    }
  }

  _maybeRestoreScroll() {
    if (!window.scrollPreserverCache[this.id]) return

    // hide the overflow as dynamically scrolling
    // shows the scroll bar for a second
    let overflow = this.element.style['overflow']
    this.element.style['overflow'] = 'hidden'

    // scroll our content to the desired position
    this.element.scrollTop = window.scrollPreserverCache[this.id].top
    this.element.scrollLeft = window.scrollPreserverCache[this.id].left

    // restore the overflow
    this.element.style['overflow'] = overflow
  }
}
