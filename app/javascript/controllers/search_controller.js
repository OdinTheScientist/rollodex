import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "clear"]

  connect() {
    this._timer = null
    this._toggleClear()
  }

  search() {
    clearTimeout(this._timer)
    this._toggleClear()
    this._timer = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }

  clear() {
    this.inputTarget.value = ""
    this._toggleClear()
    this.inputTarget.focus()
    this.element.requestSubmit()
  }

  _toggleClear() {
    this.clearTarget.classList.toggle("hidden", this.inputTarget.value === "")
  }
}
