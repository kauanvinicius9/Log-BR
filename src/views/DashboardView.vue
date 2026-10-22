<script setup lang="ts">
import AppFilterBar from "@/components/common/AppFilterBar.vue"
import KPICard from "@/components/common/KPICard.vue"
import IndicatorCharts from "@/components/dashboard/IndicatorCharts.vue"
import IndicatorGrid from "@/components/dashboard/IndicatorGrid.vue"
</script>

<template>
  <div class="p-6 space-y-6">
    <AppFilterBar />
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <KPICard :indicator="{ name: 'Total de Materiais', value: 1240, unit: 'un', meta: 1500, tendence: 5 }"/>
      <KPICard :indicator="{ name: 'Ordens Pendentes', value: 18, unit: 'ord', meta: 10, tendence: -2 }" />
      <KPICard :indicator="{ name: 'Itens Críticos', value: 5, unit: 'itens', meta: 0, tendence: -10 }" />
    </div>

    <IndicatorCharts />
    <IndicatorGrid />
  </div>
</template>