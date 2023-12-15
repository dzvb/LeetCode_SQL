-- Table: Trips

-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | id          | int      |
-- | client_id   | int      |
-- | driver_id   | int      |
-- | city_id     | int      |
-- | status      | enum     |
-- | request_at  | date     |     
-- +-------------+----------+
-- id is the primary key (column with unique values) for this table.
-- The table holds all taxi trips. Each trip has a unique id, while client_id and driver_id are foreign keys to the users_id at the Users table.
-- Status is an ENUM (category) type of ('completed', 'cancelled_by_driver', 'cancelled_by_client').
 

-- Table: Users

-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | users_id    | int      |
-- | banned      | enum     |
-- | role        | enum     |
-- +-------------+----------+
-- users_id is the primary key (column with unique values) for this table.
-- The table holds all users. Each user has a unique users_id, and role is an ENUM type of ('client', 'driver', 'partner').
-- banned is an ENUM (category) type of ('Yes', 'No').
 

-- The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

-- Write a solution to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03". Round Cancellation Rate to two decimal points.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Trips table:
-- +----+-----------+-----------+---------+---------------------+------------+
-- | id | client_id | driver_id | city_id | status              | request_at |
-- +----+-----------+-----------+---------+---------------------+------------+
-- | 1  | 1         | 10        | 1       | completed           | 2013-10-01 |
-- | 2  | 2         | 11        | 1       | cancelled_by_driver | 2013-10-01 |
-- | 3  | 3         | 12        | 6       | completed           | 2013-10-01 |
-- | 4  | 4         | 13        | 6       | cancelled_by_client | 2013-10-01 |
-- | 5  | 1         | 10        | 1       | completed           | 2013-10-02 |
-- | 6  | 2         | 11        | 6       | completed           | 2013-10-02 |
-- | 7  | 3         | 12        | 6       | completed           | 2013-10-02 |
-- | 8  | 2         | 12        | 12      | completed           | 2013-10-03 |
-- | 9  | 3         | 10        | 12      | completed           | 2013-10-03 |
-- | 10 | 4         | 13        | 12      | cancelled_by_driver | 2013-10-03 |
-- +----+-----------+-----------+---------+---------------------+------------+
-- Users table:
-- +----------+--------+--------+
-- | users_id | banned | role   |
-- +----------+--------+--------+
-- | 1        | No     | client |
-- | 2        | Yes    | client |
-- | 3        | No     | client |
-- | 4        | No     | client |
-- | 10       | No     | driver |
-- | 11       | No     | driver |
-- | 12       | No     | driver |
-- | 13       | No     | driver |
-- +----------+--------+--------+
-- Output: 
-- +------------+-------------------+
-- | Day        | Cancellation Rate |
-- +------------+-------------------+
-- | 2013-10-01 | 0.33              |
-- | 2013-10-02 | 0.00              |
-- | 2013-10-03 | 0.50              |
-- +------------+-------------------+

WITH
    trips_filtered AS (
        SELECT
            *
        FROM
            Trips
        WHERE
            client_id IN (SELECT users_id FROM Users WHERE banned = 'No' AND role = 'client')
        AND
            driver_id IN (SELECT users_id FROM Users WHERE banned = 'No' AND role = 'driver')
    )

    SELECT
        request_at AS Day,
        ROUND( AVG(CASE WHEN status = 'cancelled_by_driver' OR status = 'cancelled_by_client' THEN 1 ELSE 0 END), 2 ) AS "Cancellation Rate"
    FROM
        trips_filtered
    WHERE
        request_at IN ('2013-10-01', '2013-10-02', '2013-10-03')
    GROUP BY
        request_at