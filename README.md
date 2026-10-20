## Log-BR Project Documentation

## Overview

**Log-BR** is a web application aimed at monitoring and logistics management (dashboards, KPIs, material and order control). Developed with **Vue.js 3**, **TypeScript**, **Vite**, **Pinia** and **Sass**, the project offers a modular interface with support for unit tests and end-to-end (E2E) tests.

---


## Architecture and Core Modules

### **Reusable Components (`src/components/common`)**

* **`AppHeader.vue`**: Navigation header and application identification.
* **`AppFilterBar.vue`**: Shared filter bar for filtering metrics and tables.
* **`KPICard.vue`**: Visual card for displaying key performance indicators (KPIs).

### **Application Modules (`src/components/`)**

* **`dashboard/`**: Contains the indicator grid (`IndicatorGrid.vue`) and charts (`IndicatorCharts.vue`).
* **`materials/`**: Detailed table for materials management (`MaterialTable.vue`).
* **`orders/`**: List of transport and logistics orders (`OrderList.vue`).

### **Composables and Status (`src/composables` & `src/stores`)**

* **`useFilters.ts`**: Reactive logic for managing search filters.
* **`useMockData.ts`**: Provision of simulated data for testing and dashboard prototyping.
* **`stores/ counter.ts`**: Global state management via Pinia.

---

## Technologies Used

* **Framework:** Vue.js 3 (Composition API)
* **Build Tool:** Vite
* **Language:** TypeScript
* **Styling:** SCSS / Sass
* **Unit Tests:** Vitest
* **E2E Tests:** Cypress

---

## How to Execute the Project

### Prerequisites

* Node.js (version 18 or higher)
* npm or yarn

### Commands

1. **Install dependencies:**

   ```bash
   npm install
   ```

2. **Run in development mode:**

   ```bash
   npm run dev
   ```

3. **Run unit tests:**

   ```bash
   npm run test:unit
   ```

4. **Run E2E Tests:**

   ```bash
   npm run test:e2e
   ```

5. **Build for production:**

   ```bash
   npm run build
   ```
