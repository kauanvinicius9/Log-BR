describe("Log-BR Portal E2E Flow", () => {
    beforeEach(() => {
        cy.visit("/");
    });

    it("displays portal header and default components", () => {
        cy.get(".app-header").should("be.visible");
        cy.contains("h1", "Log-BR");
        cy.get(".filter-bar").should("be.visible");
        cy.get(".indicator-grid").should("be.visible");
        cy.get(".table-container").should("be.visible");
    });

    it("filters materials by plant SP-01", () => {
        cy.get("#select-plant").select("SP-01");
        cy.get("table tbody tr").each(($row) => {
            cy.wrap($row).contains("SP-01");
        });
    });

    it("searches materials dynamically by text input", () => {
        cy.get("#input-search").type("Palete");
        cy.get("table tbody tr").should("have.length", 1);
        cy.get("table tbody").contains("Palete PBR 1200x1200");
    });

    it("resets global filters back to default state", () => {
        cy.get("#select-plant").select("RJ-01");
        cy.get("#input-search").type("Filme");
        cy.get(".btn-reset").click();

        cy.get("#select-plant").should("have.value", "All");
        cy.get("#input-search").should("have.value", "");
    });
});