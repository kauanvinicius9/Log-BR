<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router"
import AppHeader from "./components/common/AppHeader.vue"
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <AppHeader />

    <nav class="bg-white border-b px-6 py-3 flex gap-6 text-sm font-medium">
      <RouterLink to="/" active-class="text-blue-600 font-bold">Dashboard</RouterLink>
      <RouterLink to="/materiais" active-class="text-blue-600 font-bold">Materiais</RouterLink>
      <RouterLink to="/ordens" active-class="text-blue-600 font-bold">Ordens</RouterLink>
    </nav>

    <main class="flex-1">
      <RouterView />
    </main>
  </div>
</template>