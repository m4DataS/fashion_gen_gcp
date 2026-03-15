# FashionGen BigQuery Portfolio

## Overview

This repository showcases SQL queries and data analysis workflows developed using **Google BigQuery**.  
It includes examples of data exploration, transformation, and reporting on large-scale datasets, with attention to:

- Delivered and authorized orders
- Revenue calculations in euros
- Brand and product-level aggregations
- Data validation and currency conversions

All queries are version-controlled in **GitLab** via **BigQuery Repos**, demonstrating practical SQL, cloud data warehouse skills, and reproducible analytics workflows.

---

## GCP Configuration

To connect your **BigQuery Repo** to GitLab, follow these steps:

1. **Create a BigQuery Repo**
   - In the BigQuery UI, go to **Repos → Create Repo**.
   - Give it a meaningful name (e.g., `fashiongen_repo`).

2. **Configure GitLab Connection**
   - Open your repo in BigQuery: **Repos → <your repo> → Configuration**.
   - Complete the connection form:

     ```text
     Protocole du dépôt Git distant *: HTTPS or SSH
     URL du dépôt Git distant: <your GitLab repo URL ending with .git>
     Nom de la branche par défaut: main (usually)
     Secret: <your secret from Secret Manager>
     ```

   - **Protocol:** Choose `HTTPS` or `SSH`.
   - **Repo URL:** Paste your GitLab repository URL.
   - **Default Branch:** Typically `main`.
   - **Secret:** A GitLab Personal Access Token (PAT) stored in **GCP Secret Manager**.

3. **Create and Grant Secret**
   - In **GCP Secret Manager** ([link](https://console.cloud.google.com/security/secret-manager)), create a secret with your GitLab PAT.
   - Grant the BigQuery service account the role: `roles/secretmanager.secretAccessor` to access this secret.

---

## Repository Structure

```text
queries/
    latest_order_status.sql
    monthly_delivered_revenue_eur.sql
    monthly_revenue_by_status.sql
    delivered_products_distribution.sql
    revenue_per_brand.sql
queries_explanations/
    latest_order_status.md
    monthly_delivered_revenue_eur.md
    monthly_revenue_by_status.md
    delivered_products_distribution.md
    revenue_per_brand.md
README.md
.gitlab-ci.yml
```
