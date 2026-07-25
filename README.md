# Southeast Community Bank Peer Benchmarking Dashboard

## Overview
This project benchmarks Southeast U.S. community banks (Georgia, South Carolina, and Tennessee) with $1B–$10B in total assets, using data from the FDIC's BankFind Suite. It was built around a hypothetical stakeholder scenario: a regional bank's risk and strategy team wants to know how they compare to peers, and where they should focus improvement efforts.

## Tools Used
- **Excel** — data cleaning, validation, and unit correction
- **SQL (SQLite)** — peer group averages, rankings, year-over-year growth (self-joins), and risk-flag identification (CTEs)
- **Power BI** — interactive dashboard with trend charts, peer rankings, and conditional formatting

## Data Source
FDIC BankFind Suite, Financial Reports tool (banks.data.fdic.gov/bankfind-suite/financialreporting). Data pulled for Q1 2020, Q1 2022, Q1 2024, and Q1 2026 across Georgia, South Carolina, and Tennessee, filtered to banks with $1B–$10B in total assets (179 bank-year records, 67 unique banks).

## Process
1. **Data Collection** — Pulled 12 raw CSV exports (3 states × 4 years) directly from the FDIC.
2. **Data Cleaning (Excel)** — Combined all 12 files into one master table. Converted date fields, validated the join key (CERT number, not bank name, since names were found to be inconsistently spelled across years), flagged banks with complete 4-year history, and caught a units error in the raw NIM field (it was reported in dollars, not as a percentage — the correct percentage metric, NIMY, was substituted in).
3. **SQL Analysis** — Calculated peer group averages by year, ranked banks against the peer average, computed year-over-year ROA growth using a self-join, and identified underperforming/declining banks using a CTE.
4. **Power BI Dashboard** — Built trend visualizations, KPI summary cards, and color-coded ranking tables to present findings clearly.

## Key Findings
1. **Peer group profitability improved overall (2020–2026).** Average ROA grew from 1.05% to 1.36%; average ROE grew from 9.41% to 13.85%.
2. **Net interest margin compressed during the 2022–2024 rate-hike cycle**, dropping from 3.68% to 3.19%, before recovering to 3.80% by 2026 — a sector-wide pattern, not a bank-specific issue.
3. **Performance spread across peers is wide.** Top performer United Bank posted 2.59% ROA in 2026, while the lowest performer, Morris Bank, posted -0.45% — despite both being in the same asset-size peer group.
4. **Three banks were flagged as underperforming and declining** (Morris Bank, Southeast Bank, Mountain Commerce Bank). Their efficiency ratios (a measure of operating cost relative to revenue) rose sharply — Morris Bank's efficiency ratio climbed from 62.7% to 106.1% between 2024 and 2026 — while their loan quality metrics stayed clean. This points to a cost-control problem, not a credit-risk problem.
5. **Growth leaders worth studying**: One Bank of Tennessee, Bank of Travelers Rest, and Georgia Banking Co. posted the strongest ROA improvement from 2024 to 2026, and could serve as internal benchmarks for the stakeholder's own bank.

## Recommendation
The stakeholder bank should benchmark its own efficiency ratio against this peer set on a quarterly basis. If it shows a pattern similar to the flagged banks — efficiency ratio climbing faster than the peer average — the recommended first step is an operating expense review, not a credit-risk review, since asset quality was not the driver of underperformance in this dataset.

## Repo Structure
- `data/` — raw FDIC exports and the combined master dataset
- `excel/` — cleaned and validated master workbook
- `sql/` — SQL queries used for peer analysis
- `powerbi/` — dashboard screenshots

## Dashboard Preview
See `BankDashboard.png` for a full view of the interactive dashboard.
