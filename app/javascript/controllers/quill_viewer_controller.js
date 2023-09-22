import { Controller } from "@hotwired/stimulus"
const Parchment = Quill.import('parchment')

// https://github.com/quilljs/quill/issues/1274#issuecomment-303619625
class IndentAttributor extends Parchment.Attributor.Style {
  add(node, value) {
    value = parseInt(value)
    if (value === 0) {
      this.remove(node)
      return true
    } else {
      return super.add(node, `${value}em`)
    }
  }
}
const IndentStyle = new IndentAttributor('indent', 'text-indent', {
  scope: Parchment.Scope.BLOCK,
  whitelist: ['1em', '2em', '3em', '4em', '5em', '6em', '7em', '8em', '9em']
})

// https://quilljs.com/guides/how-to-customize-quill/#class-vs-inline
const AlignStyle = Quill.import('attributors/style/align')
const BackgroundStyle = Quill.import('attributors/style/background')
const ColorStyle = Quill.import('attributors/style/color')
const DirectionStyle = Quill.import('attributors/style/direction')
const FontStyle = Quill.import('attributors/style/font')
const SizeStyle = Quill.import('attributors/style/size')

Quill.register(AlignStyle, true);
Quill.register(BackgroundStyle, true);
Quill.register(ColorStyle, true);
Quill.register(DirectionStyle, true);
Quill.register(FontStyle, true);
Quill.register(SizeStyle, true);
Quill.register(IndentStyle, true);

// Connects to data-controller="quill-viewer"
export default class extends Controller {
  connect() {

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
