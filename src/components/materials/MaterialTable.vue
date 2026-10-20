<template>
    <div class="table-container">
        <div class="table-header">
            <h3>Consulta de Materias e Estoques</h3>
            <span class="count-tag">{{ materials.length }} items encontrados</span>
        </div>

        <table>
            <thead>
                <tr>
                    <th @click="sortBy('code')">Código</th>
                    <th @click="sortBy('description')">Descrição</th>
                    <th>Planta</th>
                    <th>Categoria</th>
                    <th @click="sortBy('stockToday')">Estoque Atual</th>
                    <th></th>
                </tr>
            </thead>

            <tbody>
                <tr v-for="item in sortedMaterials" :key="item.code">
                    <td class="font-mono">{{ item.code }}</td>
                    <td class="font-bold">{{ item.description }}</td>
                    <td><span class="badge-plant">{{ item.plant }}</span></td>
                    <td>{{ item.category }}</td>
                    <td>{{ item.stockToday }}</td>
                    <td>
                        <span class="status-badge" :class="item.statusStock.toLowerCase()">
                            {{ item.statusStock }}
                        </span>
                    </td>
                </tr>
                <tr v-if="sortedMaterials.length === 0">
                    <td colspan="6" class="empty-state">Nenhum material encontrado</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script setup-lang="ts">
import { ref, computed } from "vue";
import { useMockData } from "@/composables/useMockData";
import type { Material } from "@/types";
import "./MaterialTable.scss";

const { materials } = useMockData();
const sortKey = ref<keyof Material>("code");
const sortAsc = ref<boolean>(true);

const sortBy = (key: keyof Material) => {
    if (sortKey.value === key) {
        sortAsc.value = !sortAsc.value; 
    } else {
        sortKey.value = key;
        sortAsc.value = true;
    }
};

const sortedMaterials = computed(() => {
    return [...materials.value].sort((a, b) => {
        let valA = a[sortKey.value];
        let valB = b[sortKey.value];

        if (valA < valB) return sortAsc.value ? -1 : 1;
        if (valA > valB) return sortAsc.value ? 1 : -1;
        return 0;
    });
});
</script>