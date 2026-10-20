<template>
    <div class="kpi-card">
        <div class="kpi-header">
            <span class="kpi-title">{{ indicator.name }}</span>
        </div>

        <div class="kpi-body">
            <span class="kpi-value">{{ indicator.value }}</span>
            <span class="kpi-unit">{{ indicator.unit }}</span>
        </div>

        <div class="kpi-footer">
            <span class="kpi-meta">Meta: {{ indicator.meta }}{{ indicator.unit }}</span>
            <span class="kpi-trend" :class="indicator.tendence >= 0 ? 'positive' : 'negative' ">
                {{ indicator.tendence >= 0 ? '+' : '-' }} {{ Math.abs(indicator.tendence) }}%
            </span>
        </div>
    </div>
</template>
<script setup lang="ts">
import type { Indicator } from "@/types";
import "./KPICard.scss";

defineProps<{
    indicator: Indicator
}>()
</script>