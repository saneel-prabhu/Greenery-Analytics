# 🪴 Greenery Analytics

This is a sandbox project using fictional ecommerce customer data to demonstrate how to use dbt to build real life ELT pipelines and data products.

Use this project to learn dbt development best practices such as model layering, data modeling, testing, documentation, macros, and exposures + dbt with traditional analytics.

## Introduction

Imagine you’re a newly minted analytics engineer at a tech startup, Greenery, that delivers flowers and houseplants. They’ve hired you as the first data person to help them understand the state of the business and determine where they need to improve to increase revenue and acquire new customers.

We will use the dbt project to build two main data products for our stakeholders:

1.  A historical customer segmentation model to help the customer experience team prioritize their support tickets.
    
2.  A business intelligence dashboard to help the Greenery management team track their key performance indicators (KPIs).
 
## Part 1: Customer Segmentation Model

 Analytics engineers can add value to the company outside of building models that lead to reports or dashboards.

Take for example a Customer Experience (CX) team that uses [Front](https://front.com/) as a customer service platform. As customers create tickets to ask for assistance, the CS team will start triaging them in the order that they are created. This is a decent first approach, but not a data-driven one.

An improvement to this would be to prioritize the tickets based on the customer segment, answering our most valuable customers first. An Analytics Engineer can build a segmentation model to identify the power users (for example, with an RFM approach) and store it in the data warehouse. The Analytics Engineering team can then export that user attribute to the support tool, allowing the CX team to build rules on top of it.

### RFM Segmentation

The goal of RFM analysis is to segment customers into groups based on how recently they made a purchase (Recency), how frequently they make purchases (Frequency), and how much money they spend (Monetary Value).

We are going to use just the Recency and Frequency matrix, and use the Monetary value as an accessory attribute. This is a common approach in companies where the Frequency and the Monetary Value are highly correlated.

**[Click here to view the code used to build Greenery’s RFM segments.](https://github.com/saneel-prabhu/data-projects/blob/main/models/marts/fct_hourly_rfm_segments.sql)**

**[Click here to view the Customer Segment Explorer data tool in Hex.](https://app.hex.tech/c437601f-be32-4d9d-9980-40b0221d3d57/app/2afd8b70-1b4d-434d-95a4-bb2c412dd6ee/latest)**


## Part 2: Ecommerce KPI Dashboard

Most data teams bring value to their organizations by helping them generate insights through traditional BI/Analytics.
  
**[Click here to view a Greenery KPI Dashboard in Hex built using the data models in this dbt project.](https://app.hex.tech/c437601f-be32-4d9d-9980-40b0221d3d57/app/8722a823-f110-4f92-9757-883090983fb9/latest)**

