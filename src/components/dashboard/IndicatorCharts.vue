<template>
    <div class="indicator-charts-grid">
        <div class="chart-grid">
            <h3 class="chart-title">Evolução de OTIF (%)</h3>
            
            <div class="chart-wrapper">
                <Line :data="otifChartData" :options="chartOptions" />
            </div>
        </div>

        <div class="chart-card">
            
        </div>
    </div>
</template>
<script setup lang="ts">
import { computed } from "vue";
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, BarElement, Title, Tooltip, Legend } from "chart.js";
import { Line, Bar } from "vue-chartjs";
import "./IndicatorCharts.scss";

ChartJS.register(CategoryScale, LinearScale, PointElement, BarElement, Title, Tooltip, Legend);

const labels = ["Semana 1", "Semana 2", "Semana 3", "Semana 4"]
const otifChartData = computed(() => ({
    labels,
    datasets: [
        {
            label: "OTIF Realizado (%)",
            backgroundColor: "#0f2c59",
            borderColor: "#0f2c59",
            data: [91, 92, 93, 94.8],
            tension: 0.4,
        },
        {
            label: "Meta (95%)",
            borderColor: "#00d26a",
            borderDash: [5, 5],
            data: [95, 95, 95, 95],
            pointRadius: 0
        }
    ],
}));

const acuracyChartData = computed(() => ({
    labels,
    datasets: [
        {
            labels: "Acurácia (%)",
            backgroundColor: "#1e40af",
            data: [97, 98, 98.5, 98.9],
        }
    ]
}));

const chartOptions = {
   responsive: true,
   maintainAspectRatio: false,
   plugins: {
    legend: {
        position: "bottom" as const,
    }
   }
}
</script>