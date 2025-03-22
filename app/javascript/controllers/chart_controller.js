import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";

Chart.register(...registerables);

export default class extends Controller {
    static values = {
        type: String,
        data: Object,
        options: { type: Object, default: {} },
    };

    static targets = ["canvas"];

    connect() {
        this.initializeChart();
    }

    disconnect() {
        if (this.chart) {
            this.chart.destroy();
        }
    }

    initializeChart() {
        if (!this.hasCanvasTarget) return;

        const ctx = this.canvasTarget.getContext("2d");

        const defaultOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: "bottom",
                },
            },
        };

        const options = { ...defaultOptions, ...this.optionsValue };

        this.chart = new Chart(ctx, {
            type: this.typeValue,
            data: this.dataValue,
            options: options,
        });
    }
    updateChartData(data) {
        if (!this.chart) return;

        this.chart.data = data;
        this.chart.update();
    }
}
