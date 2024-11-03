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


