<script setup lang="ts">
import AppFilterBar from "@/components/common/AppFilterBar.vue"
import MaterialTable from "@/components/materials/MaterialTable.vue"
</script>

<template>
  <div class="p-6 space-y-6">
    <h1 class="text-2xl font-bold">Consulta de Materiais</h1>
    <AppFilterBar />
    <MaterialTable />
  </div>
</template>