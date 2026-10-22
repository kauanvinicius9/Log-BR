<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router"
import AppHeader from "./components/common/AppHeader.vue"
import "./App.scss"
</script>

<template>
  <div>
    <AppHeader />

    <nav class="navbar">
      <RouterLink to="/" class="page">Dashboard</RouterLink>
      <RouterLink to="/materiais" class="page">Materiais</RouterLink>
      <RouterLink to="/ordens" class="page">Ordens</RouterLink>
    </nav>

    <main class="flex-1">
      <RouterView />
    </main>
  </div>
</template>