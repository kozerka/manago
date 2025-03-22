// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import Alpine from "alpinejs";
import "chartkick/chart.js";
import { Chart } from "chart.js/auto";

// Make Alpine available globally
window.Alpine = Alpine;

// Initialize Alpine
document.addEventListener("turbo:load", () => {
    Alpine.start();
});
