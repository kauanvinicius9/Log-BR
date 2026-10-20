<template>
  <div class="filter-bar">
    <div class="filter-group">
      <label for="select-plant">Planta Operacional</label>
      <select id="select-plant" :value="filters.plant" @change="onPlantChange">
        <option value="All">Todas as Plantas</option>
        <option value="SP-01">SP-O1</option>
        <option value="RJ-01">RJ-01</option>
        <option value="MG-01">MG-01</option>
        <option value="PR-01">PR-01</option>
      </select>
    </div>

    <div class="filter-group flex-grow">
      <label for="input-search">Pesquisar Material</label>
      <input id="input-search" type="text" placeholder="Código ou descrição" :value="filters.materialQuery" @input="onQueryInput" />
    </div>

    <div class="filter-group">
      <label for="select-period">Período de Análise</label>
      <select id="select-period" :value="filters.period" @change="onPeriodChange">
        <option value="'7d'">Últimos 7 dias</option>
        <option value="30d">Últimos 30 dias</option>
        <option value="90d">Últimos 90 dias</option>
        <option value="1y">Último Ano</option>
      </select>
    </div>

    <button class="btn-reset" @click="resetFilters">Limpar</button>
  </div>
</template>

<script setup lang="ts">
import { useFilters } from '@/composables/useFilters';
import type { PlantID, GlobalFilter } from '@/types';
import "./AppFilterBar.scss";

const { filters, setPlant, setMaterialQuery, setPeriod, resetFilters } = useFilters();

const onPlantChange = (e: Event) => {
  setPlant((e.target as HTMLSelectElement).value as PlantID);
};

const onQueryInput = (e: Event) => {
  setMaterialQuery((e.target as HTMLInputElement).value);
};

const onPeriodChange = (e: Event) => {
  setPeriod((e.target as HTMLSelectElement).value as GlobalFilter["period"]);
};
</script>
