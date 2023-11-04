// Entry point for the build script in your package.json

import * as bootstrap from 'bootstrap'
window.bootstrap = bootstrap

import "@hotwired/turbo-rails"
import "./controllers"
import "./turbo"
