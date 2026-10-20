<template>
    <div class="orders-container">
        <div class="orders-header">
            <h3>Acompanhamento de Pedidos</h3>
        </div>

        <div class="orders-grid">
            <div v-for="order in orders" :key="order.numberOrder" class="order-card">
                <div>
                    <div class="order-main">
                        <span class="order-number">{{ order.numberOrder }}</span>
                        <span class="order-status" :class="order.status.toLowerCase()">
                            {{ order.status.replace('_', ' ') }}
                        </span>
                    </div>

                    <div class="order-details">
                        <div><strong>Cliente:</strong>{{ order.client }}</div>
                        <div><strong>Origem:</strong>{{ order.plantOrigin }}</div>
                        <div><strong>Itens:</strong>{{ order.itensCount }}</div>
                    </div>
                </div>

                <div class="order-footer">
                    <span>Previsão:  {{ order.prevDelivery }}</span>
                    <span class="order-value">R$ {{ order.totalValue.toLocaseString("pt-BR", {minimumFractionDigits: 2 }) }}</span>
                </div>
            </div>
        </div>
    </div>
</template>
<script setup-lang = "ts">
import { useMockData } from "@/composables/useMockData";
import "./OrderList.scss";

const { orders } = useMockData();
</script>