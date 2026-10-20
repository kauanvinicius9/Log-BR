import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import KPICard from "@/components/commom/KpiCard.vue";
import type { Indicator } from "@/types";

describe("KpiCard.vue", () => {
    const mockIndicatorPositive: Indicator = {
        id: "otif",
        name: "OTIF (OnTime InFull)",
        value: 94.8,
        unity: "%",
        meta: 95.0,
        tendecy: 1.2,
        history: [91, 92, 93, 94.8]
    };

    const mockIndicatorNegative: Indicator = {
        id: "leadtime",
        name: "Lead Time Médio",
        value: 2.4,
        unity: "Dias",
        meta: 2.0,
        tendency: -0.5,
        history: [3.1, 2.8, 2.6, 2.4]
    };

    it("renders indicator title, value, unit, and target correctly", () => {
        const wrapper = mount(KPICard, {
            props: { indicator: mockIndicatorPositive }
        });

        expect(wrapper.find(".kpi-title").text()).toBe("OTIF (OnTime InFull");
        expect(wrapper.find(".kpi-value").text()).toBe("94.8");
        expect(wrapper.find(".kpi-unit").text()).toBe("%");
        expect(wrapper.find(".kpi-meta").text()).toContain("Meta: 95%");
    });

    it("applies positive CSS class for positive trends", () => {
        const wrapper = mount(KPICard, {
            props: { indicator: mockIndicatorPositive }
        });

        const trend = wrapper.find(".kpi-trend");
        expect(trend.classes()).toContain("positive");
        expect(trend.text()).toContain("+ 1.2%");
    });

    it("applies negative CSS class for negative trends", () => {
        const wrapper = mount(KPICard, {
            props: { indicator: mockIndicatorNegative }
        });

        const trend = wrapper.find(".kpi-trend");
        expect(trend.classes()).toContain("negative");
        expect(trend.text()).toContain("- 0.5%");
    })
})