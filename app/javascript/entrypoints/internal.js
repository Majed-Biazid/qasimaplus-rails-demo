// Internal entrypoint — Hotwire + Stimulus only, no React
import "@hotwired/turbo-rails"
import "./application.css"

// Stimulus controllers for internal dashboard
import { Application } from "@hotwired/stimulus"
import { registerControllers } from "stimulus-vite-helpers"

const application = Application.start()
const controllers = import.meta.glob("../controllers/**/*_controller.js", { eager: true })
registerControllers(application, controllers)
