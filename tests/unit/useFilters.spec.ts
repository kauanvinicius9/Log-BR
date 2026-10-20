import { describe, it, expect, beforeEach } from "vitest";
import { useFilters } from "@/composables/useFilter";

describe("useFiltes Composables", () => {
    const { filters, setPlant, setMaterialQuery, setPeriod, resetFilters } = useFilters();

    beforeEach(() => {
        resetFilters();
    });

    it("should initialize width default filters", () => {
        expect(filters.value.plant).toBe("All");
        expect(filters.value.materialQuery).toBe("");
        expect(filters.value.period).toBe("30d");
    });

    it("should update plant selection correctly", () => {
        setPlant("SP-01");
        expect(filters.value.plant).toBe("SP-01");
    });

    it("should update material query correctly", () => {
        setMaterialQuery("Palete");
        expect(filters.value.materialQuery).toBe("Palete");
    });

    it("should uptade period selection correctly", () => {
        setPeriod("90d");
        expect(filters.value.period).toBe("90d");
    });

    it("should reset filters back to defaults", () => {
        setPlant("RJ-01");
        setMaterialQuery("Caixa");
        setPeriod("7d");

        resetFilters();

        expect(filters.value.plant).toBe("All");
        expect(filters.value.materialQuery).toBe("");
        expect(filters.value.period).toBe("30d");
    });
});