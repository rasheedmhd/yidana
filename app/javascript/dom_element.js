
export default class {
  static fromTemplate(template) {
    return new DOMParser().parseFromString(template, 'text/html').body.children[0]
  }
}
