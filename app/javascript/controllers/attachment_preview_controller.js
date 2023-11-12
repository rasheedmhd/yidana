import { Controller } from "@hotwired/stimulus"

import getIconByMime from "../mime_icon"
import DomElement from "../dom_element"

// Connects to data-controller="attachment-preview"
export default class extends Controller {
  static targets = ["thumbnail", "thumbnailLink"]
  static values = {
    mimeType: String,
    thumbnailUrl: String,
  }

  connect() {
    if (!this.hasThumbnailTarget) return;

    if (this.thumbnailUrlValue)
      this.useThumbnailPreview()
    else
      this.useMimeIconPreview()
  }

  remove() {
    this.element.remove()
  }

  useThumbnailPreview() {
    const thumbnail = DomElement.fromTemplate(`
      <image src="${this.thumbnailUrlValue}" />
    `)
    thumbnail.style["width"] = "100%"
    thumbnail.style["height"] = "100%"
    thumbnail.style["object-fit"] = "contain"

    this.thumbnailLinkTarget.innerHTML = null
    this.thumbnailLinkTarget.appendChild(thumbnail)
  }

  useMimeIconPreview() {
    const mime = getIconByMime(this.mimeTypeValue)
    mime.icon.style["height"] = "70%"
    mime.icon.style["width"] = "60%"
    mime.icon.style["background-color"] = "white"
    mime.icon.classList.add("rounded", "shadow-lg")

    this.thumbnailTarget.style["background-color"] = mime.color
    // this.thumbnailLinkTarget.style["background-color"] =
    this.thumbnailLinkTarget.innerHTML = null
    this.thumbnailLinkTarget.appendChild(mime.icon)
  }
}
