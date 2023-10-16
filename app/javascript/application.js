// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import * as bootstrap from 'bootstrap'
window.bootstrap = bootstrap

// Monkeypatch to fix turbo issue of wrong turbo-frame
// See: https://github.com/hotwired/turbo/pull/579
document.addEventListener("turbo:before-fetch-request", (event) => {
  const targetTurboFrame = event.target.getAttribute("data-turbo-frame");
  const fetchTurboFrame = event.detail.fetchOptions.headers["Turbo-Frame"];
  if (
    targetTurboFrame &&
    targetTurboFrame != fetchTurboFrame &&
    document.querySelector(`turbo-frame#${targetTurboFrame}`)
  ) {
    event.detail.fetchOptions.headers["Turbo-Frame"] = targetTurboFrame;
  }
});

// // Reload the entire page if we are missing a frame
// // See: https://stackoverflow.com/a/75704489/644571
// document.addEventListener("turbo:frame-missing", (event) => {
//   if (event.target.id != 'modal') return

//   const { detail: { response, visit } } = event;
//   event.preventDefault();
//   visit(response);
// });

// Add a redirect stream action
Turbo.StreamActions.redirect = function () {
  // See: https://github.com/hotwired/turbo/issues/554
  Turbo.clearCache();

  const url = this.getAttribute("url")
  Turbo.visit(url)
}

eventNames = [
  'turbo:click',
  'turbo:before-visit',
  'turbo:visit',
  'turbo:submit-start',
  'turbo:before-fetch-request',
  'turbo:before-fetch-response',
  'turbo:submit-end',
  'turbo:before-cache',
  'turbo:before-render',
  'turbo:before-stream-render',
  'turbo:render',
  'turbo:load',
  'turbo:before-frame-render',
  'turbo:frame-render',
  'turbo:frame-load',
  'turbo:frame-missing',
  'turbo:fetch-request-error',
]

eventNames.forEach(eventName => {
  document.addEventListener(eventName, (event) => {
    console.log(event.type, event);
  });
});

// See: https://github.com/hotwired/turbo/pull/556
document.addEventListener('turbo:reload', (event) => {
  console.error(event.type, event);
});

// Disable turbo
// Turbo.session.drive = false
