# Layoffs Data Analysis Project

## Overview
This project performs comprehensive data cleaning and exploratory data analysis (EDA) on a layoffs dataset, providing insights into company workforce reductions across multiple dimensions including geography, industry, and time periods.

---

## Project Structure

### 1. Data Cleaning (`Cleaning Data.sql`)

The data cleaning process follows industry best practices with a systematic four-step approach:

#### **Step 1: Remove Duplicates**
- Created a working copy (`layoffs_cleaned`) to preserve the original dataset
- Implemented `ROW_NUMBER()` window function to identify duplicates
- Used Common Table Expressions (CTEs) to partition data by key fields:
  - Company, location, industry, total_laid_off, percentage_laid_off, date
- Generated clean dataset (`layoffs_cleaned_v2`) with duplicates removed

#### **Step 2: Standardize Data**
- **Text Cleaning**: Trimmed whitespace from company names
- **Industry Consolidation**: Unified variations (e.g., 'Crypto Currency', 'CryptoCurrency' → 'Crypto')
- **Location Correction**: Fixed character encoding issues (Düsseldorf, Florianópolis, Malmö)
- **Country Formatting**: Removed trailing periods from country names
- **Date Conversion**: Transformed date column from text to proper DATE format using `STR_TO_DATE()`

#### **Step 3: Handle Null/Blank Values**
- Converted blank industry values to NULL for consistency
- Implemented self-join logic to impute missing industry values based on matching company names
- Removed records where both `total_laid_off` and `percentage_laid_off` were NULL (no meaningful layoff data)
- Deleted records with NULL dates that couldn't be imputed

#### **Step 4: Remove Unnecessary Columns**
- Assessed all columns for relevance
- Determined all existing columns were necessary for analysis

---

### 2. Exploratory Data Analysis (`EDA.sql`)

Comprehensive analysis to uncover trends, patterns, and insights:

#### Key Metrics Analyzed

**Layoff Scale Analysis**
- Maximum layoffs in a single event
- Percentage laid off (min/max)
- Companies with 100% workforce reduction (complete shutdowns)
- Startups that went out of business ranked by funds raised

**Company-Level Insights**
- Top 5 companies by single largest layoff event
- Top 10 companies by total cumulative layoffs
- Year-over-year ranking of top 3 companies with most layoffs per year

**Geographic Analysis**
- Top 10 locations by total layoffs
- Country-wise layoff distribution

**Industry Analysis**
- Layoffs aggregated by industry sector
- Identification of most affected industries

**Temporal Analysis**
- Year-over-year layoff trends
- Monthly rolling total of layoffs
- Time series analysis using window functions

**Company Stage Analysis**
- Layoffs grouped by company stage (seed, series A/B/C, post-IPO, etc.)

---

## Technical Highlights

### SQL Techniques Demonstrated
- **Window Functions**: `ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER()`
- **Common Table Expressions (CTEs)**: For complex queries and data transformation
- **Self-Joins**: For data imputation
- **Aggregations**: `SUM()`, `MAX()`, `MIN()`, `COUNT()`
- **Date Functions**: `YEAR()`, `SUBSTRING()`, `STR_TO_DATE()`
- **String Functions**: `TRIM()`, `DISTINCT()`
- **Data Definition Language (DDL)**: `CREATE TABLE`, `ALTER TABLE`, `MODIFY COLUMN`
- **Data Manipulation Language (DML)**: `INSERT`, `UPDATE`, `DELETE`

---

## Key Findings

### Data Quality Improvements
- Successfully removed duplicate records
- Standardized industry classifications
- Corrected geographic naming inconsistencies
- Converted dates to proper format for temporal analysis

### Analytical Insights
- Identified companies with complete workforce elimination (100% laid off)
- Notable findings include startups with significant funding that went out of business
- Tracked rolling totals to understand cumulative impact over time
- Revealed year-over-year trends and seasonal patterns in layoffs

---

## Database Schema

### Primary Table: `layoffs_cleaned_v2`

| Column | Type | Description |
|--------|------|-------------|
| company | VARCHAR | Company name |
| location | VARCHAR | City/location of layoffs |
| industry | VARCHAR | Industry sector |
| total_laid_off | INT | Number of employees laid off |
| percentage_laid_off | DECIMAL | Percentage of workforce laid off |
| date | DATE | Date of layoff event |
| stage | VARCHAR | Company funding stage |
| country | VARCHAR | Country location |
| funds_raised_millions | DECIMAL | Total funds raised in millions |

---

## How to Use

1. **Setup**: Execute `Cleaning Data.sql` first to create clean dataset
2. **Analysis**: Run queries from `EDA.sql` to generate insights
3. **Customization**: Modify queries to explore specific dimensions of interest
