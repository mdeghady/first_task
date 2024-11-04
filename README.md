# Property Data Standardization and Matching

## Overview
This project aims to standardize and unify real estate property data from two different sources: `dbusa_property` and `reonomy_property`. The goal is to increase the value of this data by creating a consistent format, resolving duplicates, and identifying unique properties. Using dbt (data build tool) and Splink, we standardize, clean, and match records to obtain a unified view of properties.

### Data Sources
1. **DBUSA Property**: This dataset describes properties from the **tenants' perspective**. Each record represents a tenant (person or company) associated with a property or a part of it.
2. **Reonomy Property**: This dataset provides information from the **property perspective**, focusing on the details of each property as a unique entity.

### Address Hierarchy
For accurate property matching, addresses in the United States are standardized using a descending hierarchy:
I created a dbt model for every Hierarchy level of them 

- **State**
- **County**
- **City**
- **Zip Code**
- **Street Address**



## Requirements and Implementation
1. **Unique Properties**:
   - Extract unique properties from the combined datasets.
   - Standardize column names to lowercase (e.g., `name` instead of `property_name`).
   - Assign unique IDs using MD5 hashing based on concatenated columns that uniquely identify each property.

2. **Matching Properties**:
   - Match properties between `dbusa_property` and `reonomy_property` using Splink, leveraging address components for comparison.

## DBT Moedels
This project involves building a data warehouse with a three-layer architecture: **Staging**, **Intermediate**, and **Presentation** layers. The goal is to efficiently store, transform, and provide data to support analysis and reporting.

- **Staging Layer**: The staging layer is where raw data from the two sources (dbusa , reonomy) is ingested into the data warehouse. This data is extracted from source systems and loaded in its original form with minimal processing. The purpose of this layer is to hold data temporarily until it’s ready for further transformation in the intermediate layer.
  
  - **Objective**: Ensure data integrity and store unprocessed data for validation and auditing.
  - **Typical Contents**: Raw tables that mirror source systems (e.g., CSV files, database extracts).
  - **Updates**: Data in this layer is refreshed frequently to reflect the latest source information.

- **Intermediate Layer**: This layer performs data transformations, data cleaning, and enrichment. Data in this layer is standardized, deduplicated, and transformed to a schema that suits business needs.

  - **Objective**: Create a clean, unified dataset that can be easily queried in the presentation layer.
  - **Typical Contents**: Multiple tables for every geographic part in USA (state , , county , city ,address , zip cpde )
  - **Processes**: Includes joins, creating foreign and primary keys, aggregations, and data quality checks.

- **Presentation Layer**: This layer is designed for end-user access, providing data models optimized for reporting and analysis. The data is organized and structured to be ingested to splink linkeage model.

  - **Objective**: Provide an intuitive, performant interface for reporting and analytics.
  - **Typical Contents**: reonomy and dbusa sources data after cleaning the usa geographic parts in the intermediate layer
  - **Examples**: dbusa_presentation & reonomy_presentation
