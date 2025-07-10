-- =================================================================
-- UBER SUPPLY-DEMAND GAP ANALYSIS Using SQL
-- =================================================================

-- Step 1: Database Setup
-- -----------------------------------------------------------------
-- Create the database for the analysis and select it for use.
CREATE DATABASE IF NOT EXISTS uber_analysis;
USE uber_analysis;

-- Step 2: Table Cleanup and Creation
-- -----------------------------------------------------------------
-- Drop old tables to ensure a clean start for the script.
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS trips_staging;

-- Create a staging table to load raw data. Using VARCHAR for all columns
-- is a robust way to handle import of potentially messy data (e.g., from a CSV).
CREATE TABLE trips_staging (
    request_id VARCHAR(255),
    pickup_point VARCHAR(255),
    driver_id VARCHAR(255),
    status VARCHAR(255),
    request_timestamp VARCHAR(255),
    drop_timestamp VARCHAR(255),
    request_date VARCHAR(255),
    request_hour VARCHAR(255),
    request_day VARCHAR(255),
    trip_duration_min VARCHAR(255),
    demand VARCHAR(255),
    supply VARCHAR(255),
    hour VARCHAR(255),
    time_of_day VARCHAR(255)
);

-- Create the final, structured table with proper data types for analysis.
CREATE TABLE trips (
    request_id INT PRIMARY KEY,
    pickup_point VARCHAR(50),
    driver_id INT,
    status VARCHAR(50),
    request_timestamp DATETIME,
    drop_timestamp DATETIME,
    request_date DATE,
    request_hour INT,
    request_day VARCHAR(20),
    trip_duration_min DECIMAL(10, 2),
    demand TINYINT,
    supply TINYINT,
    hour INT,
    time_of_day VARCHAR(50)
);

-- Step 3: ETL - Extract, Transform, Load
-- -----------------------------------------------------------------
-- NOTE: This step assumes 'trips_staging' has been populated, for example, from a CSV file using a LOAD DATA INFILE command.
-- This query cleans the data from the staging table and inserts it into the final 'trips' table.
INSERT INTO trips (
    request_id, pickup_point, driver_id, status, request_timestamp,
    drop_timestamp, request_date, request_hour, request_day,
    trip_duration_min, demand, supply, hour, time_of_day
)
SELECT
    request_id,
    pickup_point,
    IF(driver_id = '', NULL, driver_id), -- Convert empty strings to NULL for data integrity
    status,
    STR_TO_DATE(request_timestamp, '%Y-%m-%d %H:%i:%s'), -- Convert string to DATETIME
    IF(drop_timestamp = '', NULL, STR_TO_DATE(drop_timestamp, '%Y-%m-%d %H:%i:%s')), -- Handle NULLs and convert to DATETIME
    STR_TO_DATE(request_date, '%Y-%m-%d'), -- Convert string to DATE
    request_hour,
    request_day,
    IF(trip_duration_min = '', NULL, trip_duration_min), -- Convert empty strings to NULL
    demand,
    supply,
    hour,
    time_of_day
FROM
    trips_staging;

-- =================================================================
-- Step 4: Data Analysis Queries
-- =================================================================

-- Query 1: Basic Health Check - View a sample of the cleaned data.
SELECT * FROM trips LIMIT 10;

-- Query 2: Overall Trip Status Distribution
-- This query provides a high-level overview of how many requests were completed vs. failed.
SELECT
    status,
    COUNT(request_id) AS number_of_requests,
    ROUND((COUNT(request_id) * 100.0 / (SELECT COUNT(*) FROM trips)), 2) AS percentage
FROM
    trips
GROUP BY
    status;

-- Query 3: Problem Analysis by Pickup Point
-- This helps identify if certain locations are more prone to specific issues.
SELECT
    pickup_point,
    status,
    COUNT(request_id) AS number_of_requests
FROM
    trips
GROUP BY
    pickup_point, status
ORDER BY
    pickup_point, number_of_requests DESC;

-- Query 4: Identify Most Problematic Times of Day
-- Calculates the "gap percentage" (non-completed trips) for each time slot.
SELECT
    time_of_day,
    COUNT(request_id) AS total_requests,
    ROUND(SUM(CASE WHEN status != 'Trip Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(request_id), 2) AS gap_percentage
FROM
    trips
GROUP BY
    time_of_day
ORDER BY
    gap_percentage DESC;

-- Query 5: Detailed Breakdown by Pickup Point and Time (Raw Counts)
-- A pivot table showing the raw counts for each status, segmented by location and time.
SELECT
    pickup_point,
    time_of_day,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_trips,
    SUM(CASE WHEN status = 'No Cars Available' THEN 1 ELSE 0 END) AS no_cars_available,
    SUM(CASE WHEN status = 'Trip Completed' THEN 1 ELSE 0 END) AS completed_trips,
    COUNT(request_id) AS total_requests
FROM
    trips
GROUP BY
    pickup_point, time_of_day
ORDER BY
    total_requests DESC;

-- Query 6: Core Problem Analysis - Cancellation vs. Unavailability Rates
-- This is the key query that calculates the precise rates of cancellation and car unavailability,
-- allowing for direct comparison and identification of the main problems.
SELECT
    pickup_point,
    time_of_day,
    ROUND(SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(request_id), 2) AS cancellation_rate,
    ROUND(SUM(CASE WHEN status = 'No Cars Available' THEN 1 ELSE 0 END) * 100.0 / COUNT(request_id), 2) AS no_cars_rate
FROM
    trips
GROUP BY
    pickup_point, time_of_day
ORDER BY
    cancellation_rate DESC, no_cars_rate DESC;

-- =================================================================
-- End of Script
-- =================================================================