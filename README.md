Important Note:
I had to manually create the CoffeeClub tables first before running any constraints, indexes, or views.
The database I initially connected to did not contain the CoffeeClub tables, so I created:

customers

offers

offer_channels

events

using the schema provided in the assignment.

Only after creating these tables was I able to run:

ALTER TABLE

CREATE INDEX

CREATE VIEW

Feature engineering updates


Task 3 — Analytics: Offer Aggregations
This task required building SQL Views that allow non‑technical users to understand offer performance.

View 1 — offer_summary (Received vs Completed)
Counts how many times each offer was received and completed, plus completion rate.
CREATE OR REPLACE VIEW offer_summary AS
SELECT
    e.offer_id,
    COUNT(*) FILTER (WHERE e.event = 'offer received') AS received_count,
    COUNT(*) FILTER (WHERE e.event = 'offer completed') AS completed_count,
    CASE
        WHEN COUNT(*) FILTER (WHERE e.event = 'offer received') = 0 THEN NULL
        ELSE ROUND(
            COUNT(*) FILTER (WHERE e.event = 'offer completed')::NUMERIC
            / COUNT(*) FILTER (WHERE e.event = 'offer received'),
            3
        )
    END AS completion_rate
FROM events e
GROUP BY e.offer_id;



View 2 — informational_offer_transactions
Counts how many transactions happened after receiving an informational offer.
CREATE OR REPLACE VIEW offer_summary AS
SELECT
    e.offer_id,
    COUNT(*) FILTER (WHERE e.event = 'offer received') AS received_count,
    COUNT(*) FILTER (WHERE e.event = 'offer completed') AS completed_count,
    CASE
        WHEN COUNT(*) FILTER (WHERE e.event = 'offer received') = 0 THEN NULL
        ELSE ROUND(
            COUNT(*) FILTER (WHERE e.event = 'offer completed')::NUMERIC
            / COUNT(*) FILTER (WHERE e.event = 'offer received'),
            3
        )
    END AS completion_rate
FROM events e
GROUP BY e.offer_id;





4. Task 4 — Demographic Feature Scaling
This task prepared customer data for demographic reporting.

Income Buckets
ALTER TABLE customers
    ADD COLUMN income_bucket TEXT;

UPDATE customers
SET income_bucket = CASE
    WHEN income IS NULL THEN 'Unknown'
    WHEN income < 40000 THEN 'Low'
    WHEN income BETWEEN 40000 AND 80000 THEN 'Medium'
    WHEN income > 80000 THEN 'High'
END;



Age Groups
sql
ALTER TABLE customers
    ADD COLUMN age_group TEXT;

UPDATE customers
SET age_group = CASE
    WHEN age IS NULL THEN 'Unknown'
    WHEN age < 25 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age >= 55 THEN '55+'
END;
These engineered features make demographic reporting much faster and easier.


5. Group Role Breakdown

   Task 3 — Analytics
Built SQL Views

Calculated completion rates

Counted transactions after informational offers

Task 4 — Demographic Bucketing
Created income buckets

Created age groups

Prepared customer data for reporting
