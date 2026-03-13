import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { src: String }

  swap() {
    const fallback = this.srcValue
    if (!fallback) return
    this.element.src = fallback
  }
}
