import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Add external dependencies
import ReadMore from 'stimulus-read-more'
application.register('read-more', ReadMore)

import Timeago from 'stimulus-timeago'
application.register('timeago', Timeago)

import TextareaAutogrow from 'stimulus-textarea-autogrow'
application.register('textarea-autogrow', TextareaAutogrow)

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
