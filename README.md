## Log-BR Project Documentation

## 1. Overview

**Log-BR** is a web application aimed at monitoring and logistics management (dashboards, KPIs, material and order control). Developed with **Vue.js 3**, **TypeScript**, **Vite**, **Pinia** and **Sass**, the project offers a modular interface with support for unit tests and end-to-end (E2E) tests.

---

## 2. Directory and File Structure

```
Log-BR-main/
├── .editorconfig
├── .gitignore
├── .oxfmtrc.json
├── .oxlintrc.json
├── README.md
├── cypress.config.ts
├── env.d.ts
├── eslint.config.ts
├── index.html
├── package.json
├── package-lock.json
├── tsconfig.app.json
├── tsconfig.json
├── tsconfig.node.json
├── tsconfig.vitest.json
├── vite.config.ts
├── vitest.config.ts
├── cypress/
│ ├── e2e/
│ │ └── example.cy.ts
│ ├── fixtures/
│ │ └── example.json
│ └── support/
│ ├── commands.ts
│ └── e2e.ts
├── src/
│ ├── App.vue
│ ├── main.ts
│ ├── assets/
│ │ └── styles/
│ │ ├── _mixins.scss
│ │ ├── _variables.scss
│ │ └── main.scss
│ ├── components/
│ │ ├── common/
│ │ │ ├── AppFilterBar.vue
│ │ │ ├── AppFilterBar.scss
│ │ │ ├── AppHeader.vue
│ │ │ ├── AppHeader.scss
│ │ │ ├── KPICard.vue
│ │ │ └── KPICard.scss
│ │ ├── dashboard/
│ │ │ ├── IndicatorCharts.vue
│ │ │ ├── IndicatorCharts.scss
│ │ │ ├── IndicatorGrid.vue
│ │ │ └── IndicatorGrid.scss
│ │ ├── materials/
│ │ │ ├── MaterialTable.vue
│ │ │ └── MaterialTable.scss
│ │ └── orders/
│ │ ├── OrderList.vue
│ │ └── OrderList.scss
│ ├── composables/
│ │ ├── useFilters.ts
│ │ └── useMockData.ts
│ ├── router/
│ │ └── index.ts
│ ├── stores/
│ │ └── counter.ts
│ └── types/
│ └── index.ts
└── tests/
    └── unit/
        ├── KPICard.spec.vue.ts
        ├── useFilters.spec.ts
        └── e2e/
            └── portal.cy.ts
```

---

## 3. Architecture and Core Modules

### **3.1. Reusable Components (`src/components/common`)**

* **`AppHeader.vue`**: Navigation header and application identification.
* **`AppFilterBar.vue`**: Shared filter bar for filtering metrics and tables.
* **`KPICard.vue`**: Visual card for displaying key performance indicators (KPIs).

### **3.2. Application Modules (`src/components/`)**

* **`dashboard/`**: Contains the indicator grid (`IndicatorGrid.vue`) and charts (`IndicatorCharts.vue`).
* **`materials/`**: Detailed table for materials management (`MaterialTable.vue`).
* **`orders/`**: List of transport and logistics orders (`OrderList.vue`).

### **3.3. Composables and Status (`src/composables` & `src/stores`)**

* **`useFilters.ts`**: Reactive logic for managing search filters.
* **`useMockData.ts`**: Provision of simulated data for testing and dashboard prototyping.
* **`stores/ counter.ts`**: Global state management via Pinia.

---

## 4. Technologies Used

* **Framework:** Vue.js 3 (Composition API)
* **Build Tool:** Vite
* **Language:** TypeScript
* **Styling:** SCSS / Sass
* **Unit Tests:** Vitest
* **E2E Tests:** Cypress

---

## 5. How to Execute the Project

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