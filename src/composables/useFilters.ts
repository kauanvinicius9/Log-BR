import { reactive, computed } from "vue";
import type { GlobalFilter } from "@/types";

const state = reactive<GlobalFilter>({
    plant: "All",
    materialQuery: "",
    period: "30d",
});

export function useFilters() {
    const setPlant = (plant: GlobalFilter["plant"]) => {
        state.plant = plant;
    };

    const setMaterialQuery = (query: string) => {
        state.materialQuery = query;
    };

    const setPeriod = (period: GlobalFilter["period"]) => {
        state.period = period;
    };

    const resetFilters = () => {
        state.plant = "All";
        state.materialQuery = "";
        state.period = "30d";
    };

    return {
        filters: computed(() => state),
        setPlant,
        setMaterialQuery,
        setPeriod,
        resetFilters,
    };
}