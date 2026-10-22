<template>
    <div class="indicator-grid">
        <KPICard v-for="indicator in indicators" :key="indicator.id" :indicator="indicator"/>
    </div>
</template>
<script setup lang="ts">
import KPICard from '../common/KPICard.vue';
import { useMockData } from '@/composables/useMockData';
import "./IndicatorGrid.scss";

const { indicators } = useMockData();
</script>