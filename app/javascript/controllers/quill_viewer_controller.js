import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quill-viewer"
export default class extends Controller {

  connect() {
    console.log(`${this.element.textContent}`)
    const quill = new Quill(document.createElement("div"));

    const content = this.element.textContent;
    try {
      quill.setContents(JSON.parse(content))
    } catch (SyntaxError) {
      quill.setText(content)
    }

    this.element.innerHTML = quill.root.innerHTML
  }
}
