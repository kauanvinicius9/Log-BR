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

</script>