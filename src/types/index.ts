export type PlantID = "All" | "SP-01" | "RJ-01" | "MG-01" | "PR-01";

export interface GlobalFilter {
    plant: PlantID;
    materialQuery: string;
    period: "7d" | "30d" | "90d" | "1y";
}

export interface Indicator {
    id: string;
    name: string;
    value: number;
    unit: string;
    meta: number;
    tendence: number;
    history: number[];
}

export interface Material {
    code: string;
    description: string;
    plant: PlantID;
    category: string;
    stockToday: number;
    stockMin: number;
    unitMedium: "UN" | "KG" | "CX" | "TON";
    statusStock: "Normal" | "Crítico" | "Execsso";
}

export interface Order {
    numberOrder: string;
    client: string;
    plantOrigin: PlantID;
    dateEmission: string;
    prevDelivery: string;
    status: "Em_Processamento" | "Em_Trânsito" | "Entregue" | "Atrasado";
    totalValue: number;
    itensCount: number;
}