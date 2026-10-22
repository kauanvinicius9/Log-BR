import { createRouter, createWebHistory } from "vue-router"

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "dashboard",
      component: () => import("../views/DashboardView.vue")
    },
    {
      path: "/materiais",
      name: "materials",
      component: () => import("../views/MaterialsView.vue")
    },
    {
      path: "/ordens",
      name: "orders",
      component: () => import("../views/OrdersView.vue")
    }
  ],
})

export default router