-- ============================================================
-- Southeast Community Bank Peer Benchmarking
-- SQL Queries (SQLite)
-- Table: bankpeer (source: Master_Combined.csv)
-- ============================================================


-- ------------------------------------------------------------
-- Query 1: Peer group averages by year
-- Calculates the average ROA, ROE, NIM, and efficiency ratio
-- across all banks in the peer group, for each year.
-- Used to establish the benchmark trend line (2020-2026).
-- ------------------------------------------------------------
SELECT
    YEAR,
    ROUND(AVG(ROA), 2) AS avg_roa,
    ROUND(AVG(ROE), 2) AS avg_roe,
    ROUND(AVG(NIM_PERCENT), 2) AS avg_nim,
    ROUND(AVG(EEFFR), 2) AS avg_efficiency_ratio
FROM bankpeer
GROUP BY YEAR
ORDER BY YEAR;


-- ------------------------------------------------------------
-- Query 2: Bank ranking vs. peer average (2026)
-- Shows each bank's ROA, ROE, and NIM for 2026, alongside how
-- far above/below the peer average ROA (1.36) each bank is.
-- Used to identify top and bottom performers.
-- ------------------------------------------------------------
SELECT
    NAME,
    ROA,
    ROE,
    NIM_PERCENT,
    ROUND(ROA - 1.36, 2) AS roa_vs_peer_avg
FROM bankpeer
WHERE YEAR = 2026
ORDER BY roa_vs_peer_avg DESC;


-- ------------------------------------------------------------
-- Query 3: Year-over-year ROA growth (2024 -> 2026)
-- Self-join comparing each bank's 2024 ROA to its 2026 ROA,
-- matched on CERT (unique bank ID) rather than NAME, since
-- bank names were found to be inconsistently spelled across
-- years during data cleaning.
-- ------------------------------------------------------------
SELECT
    a.NAME,
    a.CERT,
    a.ROA AS roa_2024,
    b.ROA AS roa_2026,
    ROUND(b.ROA - a.ROA, 2) AS roa_change
FROM bankpeer AS a
JOIN bankpeer AS b ON a.CERT = b.CERT
WHERE a.YEAR = 2024 AND b.YEAR = 2026
ORDER BY roa_change DESC;


-- ------------------------------------------------------------
-- Query 4: Risk flags - underperforming AND declining banks
-- Uses a CTE to build on Query 3's growth calculation, then
-- filters to banks that are both below the 2026 peer average
-- ROA (1.36) and have a negative 2024->2026 ROA change.
-- Identifies banks warranting a closer stakeholder review.
-- ------------------------------------------------------------
WITH growth AS (
    SELECT
        a.NAME,
        a.CERT,
        b.ROA AS roa_2026,
        (b.ROA - a.ROA) AS roa_change
    FROM bankpeer AS a
    JOIN bankpeer AS b ON a.CERT = b.CERT
    WHERE a.YEAR = 2024 AND b.YEAR = 2026
)
SELECT NAME, roa_2026, roa_change
FROM growth
WHERE roa_2026 < 1.36
  AND roa_change < 0
ORDER BY roa_change ASC;
