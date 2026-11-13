# 🚚 Supply Chain & Logistics SLA Monitoring Dashboard

[![Power BI](https://img.shields.io/badge/Power_BI_Desktop-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![DAX](https://img.shields.io/badge/DAX-Calculations-blue?style=for-the-badge)](./dax/all_measures.dax)
[![Power Query](https://img.shields.io/badge/Power_Query-M_Code-teal?style=for-the-badge)](./powerquery/etl_transformations.m)
[![Author](https://img.shields.io/badge/Author-Vani_Thummalagunti-purple?style=for-the-badge)](https://github.com/vani-thummalagunti)

An enterprise logistics and supply chain analytics dashboard developed in **Microsoft Power BI Desktop** to monitor carrier service level agreements (SLAs), On-Time In-Full (OTIF) fulfillment rates, and operational bottlenecks across 6,000 shipments.

---

## 📌 Executive Summary
* **Total Dispatched Shipments:** 6,000 Consignments
* **On-Time In-Full (OTIF) Rate:** **80.4%** (4,825 On-Time Deliveries)
* **Delayed Shipments:** 1,175 (**19.6% SLA Breach Rate**)
* **Total Freight Spend:** $440.4K (Average $73.40 / shipment)

---

## 🎯 Key Business Findings
1. **Carrier SLA Compliance:** **BlueDart (81.4% OTIF)** and **Delhivery (81.1% OTIF)** led on-time performance on domestic fulfillment routes.
2. **Top Operational Bottlenecks:** **Customs & Regulatory Holds (25.7%)** and **Transit Sorting Hub Congestion (25.1%)** accounted for over half of all customer delivery delays.
3. **Warehouse Hub Volume:** The **Delhi Hub (1,540 shipments)** handled the highest throughput with lowest transit variance.

---

## 🏗️ Data Architecture & Star Schema

```
+------------------------------+             +-------------------------------+
|         Dim_Carrier          |             |         Dim_Warehouse         |
+------------------------------+             +-------------------------------+
| Carrier (PK)                 |             | OriginWarehouse (PK)          |
+--------------+---------------+             +---------------+---------------+
               | (1)                                         | (1)
               |                                             |
               | (*)                                         | (*)
+--------------+---------------------------------------------+---------------+
|                               Fact_Shipments                               |
+----------------------------------------------------------------------------+
| ShipmentID                                                                 |
| ShipDate                                                                   |
| Carrier (FK)                                                               |
| ShippingMode                                                               |
| OriginWarehouse (FK)                                                       |
| DestinationType                                                            |
| PromisedDays                                                               |
| ActualDays                                                                 |
| DelayDays                                                                  |
| IsDelayed (Yes / No)                                                       |
| DelayReason                                                                |
| ShippingCost                                                               |
+----------------------------------------------------------------------------+
```

---

## 📐 Core DAX Measures

```dax
// Total Dispatched Shipments
Total Shipments = COUNTROWS(Fact_Shipments)

// OTIF Rate %
OTIF Rate % = 
DIVIDE(
    CALCULATE(COUNTROWS(Fact_Shipments), Fact_Shipments[IsDelayed] = "No"),
    COUNTROWS(Fact_Shipments),
    0
)

// SLA Delay Rate %
Delay Rate % = 
DIVIDE(
    CALCULATE(COUNTROWS(Fact_Shipments), Fact_Shipments[IsDelayed] = "Yes"),
    COUNTROWS(Fact_Shipments),
    0
)

// Total Freight Spend
Total Freight Cost = SUM(Fact_Shipments[ShippingCost])

// Average Lead Time (Days)
Avg Actual Lead Time = AVERAGE(Fact_Shipments[ActualDays])
```

---

## 🛠️ Data Cleaning & Transformations (Power Query M)
* **Text Normalization:** Standardized `IsDelayed` status casing to ensure clean filter paths.
* **Cost Imputation:** Replaced missing shipping freight costs with median shipping tier rates.

*(See full M-script in [`powerquery/etl_transformations.m`](./powerquery/etl_transformations.m))*

---

## 📁 Repository Structure
```text
├── README.md                      # Project documentation and schema
├── data/
│   ├── shipments_raw.csv          # Source shipments dataset
│   ├── shipments_cleaned.csv      # Cleaned dataset
│   ├── fact_shipments.csv         # Star Schema Fact table
│   ├── dim_carrier.csv            # Star Schema Dimension table
│   └── dim_warehouse.csv          # Star Schema Dimension table
├── dax/
│   └── all_measures.dax           # Documented DAX measures
├── powerquery/
│   └── etl_transformations.m      # Power Query M code
└── dashboard/
    └── index.html                 # Interactive report layout preview
```

---

## 🚀 How to Run in Microsoft Power BI Desktop
1. Open **Power BI Desktop**.
2. Click **Get Data** > **Text/CSV** and import:
   * `data/dim_carrier.csv`
   * `data/dim_warehouse.csv`
   * `data/fact_shipments.csv`
3. In **Model View**, establish 1-to-many single-direction relationships from Dimensions to Fact.
4. Create a `_Measures` table and paste the measures from `dax/all_measures.dax`.
5. Build report visuals:
   * **Cards:** Total Shipments, OTIF Rate %, Delayed Shipments, Total Freight Cost.
   * **Stacked Bar Chart:** Carrier SLA On-Time vs Delayed Performance.
   * **Donut Chart:** Delay Root Causes.
   * **Column Chart:** Warehouse Volume & Freight Spend.
   * **Slicers:** Carrier, Shipping Mode.

---

### Developed by **Vani Thummalagunti**
Connect on [LinkedIn](https://www.linkedin.com) | [GitHub Profile](https://github.com/vani-thummalagunti)
