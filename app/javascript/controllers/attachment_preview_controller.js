import { Controller } from "@hotwired/stimulus"

import getIconByMime from "../mime_icon"

// Connects to data-controller="attachment-preview"
export default class extends Controller {
  static targets = ["thumbnail", "thumbnailLink"]
  static values = {
    mimeType: String,
  }

  connect() {
    const mime = getIconByMime(this.mimeTypeValue)
    mime.icon.style["height"] = "70%"
    mime.icon.style["width"] = "60%"
    mime.icon.style["background-color"] = "white"
    mime.icon.classList.add("rounded", "shadow-lg")

    if (this.hasThumbnailTarget) {
      this.thumbnailTarget.style["background-color"] = mime.color
      // this.thumbnailLinkTarget.style["background-color"] =
      this.thumbnailLinkTarget.innerHTML = null
      this.thumbnailLinkTarget.appendChild(mime.icon)
    }
  }

  remove() {
    this.element.remove()
  }
}
