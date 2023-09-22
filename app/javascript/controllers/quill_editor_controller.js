import { Controller, del } from "@hotwired/stimulus"

// Connects to data-controller="quill-editor"
export default class extends Controller {
  static targets = ["editor", "input"]

  connect() {
    // https://codepen.io/anon/pen/rrzpGx
    const toolbarOptions = [
      ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
      ['blockquote', 'code-block'],

      [{ 'list': 'ordered' }, { 'list': 'bullet' }],
      [{ 'script': 'sub' }, { 'script': 'super' }],      // superscript/subscript

      // [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown
      [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

      [{ 'color': [] }],          // dropdown with defaults from theme
      [{ 'font': [] }],

      ['link'],

      ['clean'],                                         // remove formatting button
    ];

    this.quill = new Quill(this.editorTarget, {
      theme: 'snow',
      modules: {
        toolbar: toolbarOptions
      }
    });

    if (this.inputTarget.value) {
      try {
        // Initialize quill with the input contents
        this.quill.setContents(JSON.parse(this.inputTarget.value))
      } catch (SyntaxError) {
        this.quill.setText(this.inputTarget.value)
      }
    }

    const $this = this;
    this.quill.on('text-change', function (delta, oldDelta, source) {
      $this.inputTarget.value = JSON.stringify($this.quill.getContents())
    });
  }

  disconnect() {
    this.quill = null
  }
}
