-- Table: Stadium

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | visit_date    | date    |
-- | people        | int     |
-- +---------------+---------+
-- visit_date is the column with unique values for this table.
-- Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
-- As the id increases, the date increases as well.
 

-- Write a solution to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

-- Return the result table ordered by visit_date in ascending order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Stadium table:
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 1    | 2017-01-01 | 10        |
-- | 2    | 2017-01-02 | 109       |
-- | 3    | 2017-01-03 | 150       |
-- | 4    | 2017-01-04 | 99        |
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-09 | 188       |
-- +------+------------+-----------+
-- Output: 
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-09 | 188       |
-- +------+------------+-----------+

WITH
    lag_attendance AS (
        SELECT
            *,
            LAG(people, 1) OVER(ORDER BY id) AS people_lag_1,
            LAG(people, 2) OVER(ORDER BY id) AS people_lag_2,
            LEAD(people, 1) OVER(ORDER BY id) AS people_lead_1,
            LEAD(people, 2) OVER(ORDER BY id) AS people_lead_2
        FROM
            Stadium
    )

SELECT
    id,
    visit_date,
    people
FROM
    lag_attendance
WHERE
    (people >= 100
    AND
    people_lag_1 >= 100
    AND
    people_lag_2 >= 100)
OR
    (people >= 100
    AND
    people_lead_1 >= 100
    AND
    people_lead_2 >= 100)
OR
    (people >= 100
    AND
    people_lag_1 >= 100
    AND
    people_lead_1 >= 100)
ORDER BY
    visit_date