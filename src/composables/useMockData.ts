import { ref, computed } from "vue";
import type { Material, Order, Indicator } from "@/types";
import { useFilters } from "./useFilters";

export function useMockData() {
  const { filters } = useFilters();

  const indicators = ref<Indicator[]>([
    {
      id: "otif",
      name: "OTIF (OnTime InFull)",
      value: 94.9,
      unit: "%",
      meta: 94.0,
      tendence: 1.2,
      history: [91, 92, 93, 94, 8],
    },
    {
      id: "leadtime",
      name: "Lead Time Médio",
      value: 2.4,
      unit: "Dias",
      meta: 2.0,
      tendence: -0.5,
      history: [3.1, 2.8, 2.6, 2.5],
    },
    {
      id: "acuracia",
      name: "Acurácia de Estoque",
      value: 98.8,
      unit: "%",
      meta: 99.0,
      tendence: 0.4,
      history: [97, 98, 98.5, 98.9],
    },
    {
      id: "frete",
      name: "Custo de Frete / Faturamento",
      value: 3.2,
      unit: "%",
      meta: 3.5,
      tendence: -0.2,
      history: [3.8, 3.6, 3.4, 3.2],
    },
  ]);

  const materials = ref<Material[]>([
    {
        code: "MAT-1001",
        description: "Caixa Papelão Duplo 40x40",
        plant: "SP-01",
        category: "Embalagens",
        stockToday: 2832,
        stockMin: 490,
        unitMedium: "UN",
        statusStock: "Normal"
    },
    {
        code: "MAT-1005",
        description: "Palete PBR 1200x1200",
        plant: "SP-01",
        category: "Logística",
        stockToday: 97,
        stockMin: 500,
        unitMedium: "UN",
        statusStock: "Crítico"
    },
    {
        code: "MAT-2003",
        description: "Filme Strech 500mm x 25mic",
        plant: "MG-01",
        category: "Embalagens",
        stockToday: 5934,
        stockMin: 380,
        unitMedium: "KG",
        statusStock: "Excesso"
    },
    {
        code: "MAT-3001",
        description: "Tambor Metálico 200L Fechado",
        plant: "PR-01",
        category: "Embalagens",
        stockToday: 1932,
        stockMin: 700,
        unitMedium: "UN",
        statusStock: "Crítico"
    }
  ]);

  const orders = ref<Order[]>([
    {
        numberOrder: "P-8242",
        client: "Log Expressa",
        plantOrigin: "SP-01",
        dateEmission: "2026-03-25",
        prevDelivery: "2026-04-02",
        status: "Entregue",
        totalValue: 4933.00,
        itensCount: 12
    },
    {
        numberOrder: "P-3842",
        client: "Transportadora Sul LTDA",
        plantOrigin: "RJ-01",
        dateEmission: "2026-07-01",
        prevDelivery: "2026-07-29",
        status: "Entregue",
        totalValue: 5943.00,
        itensCount: 10
    },
    {
        numberOrder: "P-9427",
        client: "Distribuidora L.A",
        plantOrigin: "SP-01",
        dateEmission: "2026-10-19",
        prevDelivery: "2026-10-21",
        status: "Em_Trânsito",
        totalValue: 4273.00,
        itensCount: 18
    },
    {
        numberOrder: "P-1822",
        client: "Log BR",
        plantOrigin: "MG-01",
        dateEmission: "2026-10-17",
        prevDelivery: "2026-11-01",
        status: "Em_Trânsito",
        totalValue: 4733.00,
        itensCount: 7
    }
  ]);

  const materialsFilter = computed(() => {
    return materials.value.filter((m) => {
        const matchPlant = filters.value.plant === "All" || m.plant === filters.value.plant;
        const matchQuery = m.description.toLowerCase().includes(filters.value.materialQuery.toLowerCase()) ||
                                          m.code.toLowerCase().includes(filters.value.materialQuery.toLowerCase());
       return matchPlant && matchQuery;
    });
  });

  const ordersFilter = computed(() => {
    return orders.value.filter((p) => {
        return filters.value.plant === "All" || p.plantOrigin === filters.value.plant;
    });
  });

  return {
    indicators,
    materials: materialsFilter,
    orders: ordersFilter,
  };
}
