-- ========================================
-- DATABASE SETUP
-- ========================================
CREATE DATABASE HOTEL_ANALYSIS;
USE HOTEL_ANALYSIS;

-- ========================================
-- ADD FOREIGN KEYS
-- ========================================
ALTER TABLE [dbo].[reviews]
ADD CONSTRAINT USERFK
FOREIGN KEY([user_id])
REFERENCES [dbo].[users]([user_id]);

ALTER TABLE [dbo].[reviews]
ADD CONSTRAINT HOTELFK
FOREIGN KEY ([hotel_id])
REFERENCES [dbo].[hotels]([hotel_id]);

-- ========================================
-- EXPLORE TABLES
-- ========================================
SELECT * FROM hotels;
SELECT * FROM users;
SELECT * FROM reviews;

-- ========================================
-- HOTEL COUNTS
-- ========================================
-- Total number of hotels
SELECT COUNT(*) AS NUMOFHOTELS FROM hotels;

-- Number of hotels per city
SELECT COUNT(*) AS NUMOFHOTELS, CITY 
FROM hotels
GROUP BY CITY;

-- Number of hotels per country
SELECT COUNT(*) AS NUMOFHOTELS, COUNTRY
FROM hotels 
GROUP BY COUNTRY;

-- ========================================
-- USER COUNTS
-- ========================================
-- Total number of users
SELECT COUNT(*) AS NUMOFUSERS FROM users;

-- Users by gender
SELECT COUNT(*) AS NUMOFUSERS, user_gender
FROM users
GROUP BY user_gender;

-- Users by country
SELECT COUNT(*) AS NUMOFUSERS, country
FROM users
GROUP BY country;

-- Country with max users
SELECT TOP 1 country, COUNT(*) AS NUMOFUSERS
FROM users
GROUP BY country
ORDER BY COUNT(*) DESC;

-- Country with min users
SELECT TOP 1 country, COUNT(*) AS NUMOFUSERS
FROM users
GROUP BY country
ORDER BY COUNT(*) ASC;

-- Users by traveller type
SELECT COUNT(*) AS NUMOFUSERS, traveller_type
FROM users
GROUP BY traveller_type;

-- Max traveller type
SELECT TOP 1 traveller_type, COUNT(*) AS NUMOFUSERS
FROM users
GROUP BY traveller_type
ORDER BY NUMOFUSERS DESC;

-- Min traveller type
SELECT TOP 1 traveller_type, COUNT(*) AS NUMOFUSERS
FROM users
GROUP BY traveller_type
ORDER BY NUMOFUSERS ASC;

-- Age distribution
SELECT COUNT(*) AS NUMOFUSERS, age_group
FROM users
GROUP BY age_group
ORDER BY NUMOFUSERS DESC;

-- Age distribution per country
SELECT country, age_group, COUNT(*) AS NUMOFUSERS
FROM users
GROUP BY country, age_group
ORDER BY NUMOFUSERS DESC;

-- Max age group in each country
WITH RANKED AS (
    SELECT country, age_group, COUNT(*) AS NUMOFUSERS,
           ROW_NUMBER() OVER (PARTITION BY country ORDER BY COUNT(*) DESC) AS RN
    FROM users
    GROUP BY country, age_group
)
SELECT country, age_group, NUMOFUSERS
FROM RANKED
WHERE RN = 1;

-- ========================================
-- REVIEW ANALYSIS
-- ========================================
-- Total reviews per hotel
SELECT COUNT(*) AS NUMOFREVIEWS, H.hotel_name
FROM reviews R
LEFT JOIN hotels H ON R.hotel_id = H.hotel_id
GROUP BY H.hotel_name;

-- Reviews by gender
SELECT USER_GENDER, COUNT(REVIEW_ID) AS NUMOFREVIEWS
FROM USERS U
INNER JOIN REVIEWS R ON U.USER_ID = R.USER_ID
GROUP BY USER_GENDER
ORDER BY NUMOFREVIEWS DESC;

-- Reviews by age group
SELECT AGE_GROUP, COUNT(REVIEW_ID) AS NUMOFREVIEWS
FROM USERS U
INNER JOIN REVIEWS R ON U.USER_ID = R.USER_ID
GROUP BY AGE_GROUP
ORDER BY NUMOFREVIEWS DESC;

-- Reviews by traveller type
SELECT TRAVELLER_TYPE, COUNT(REVIEW_ID) AS NUMOFREVIEWS
FROM USERS U
INNER JOIN REVIEWS R ON U.USER_ID = R.USER_ID
GROUP BY TRAVELLER_TYPE
ORDER BY NUMOFREVIEWS DESC;

-- Number of distinct users per hotel
SELECT HOTEL_NAME, COUNT(DISTINCT U.USER_ID) AS NUMOFUSERS
FROM HOTELS H
LEFT JOIN REVIEWS R ON H.HOTEL_ID = R.HOTEL_ID
LEFT JOIN USERS U ON U.USER_ID = R.USER_ID
GROUP BY HOTEL_NAME
ORDER BY NUMOFUSERS DESC;

-- ========================================
-- AVERAGE SCORES ANALYSIS
-- ========================================
-- Average overall score per hotel
SELECT HOTEL_NAME, ROUND(AVG(SCORE_OVERALL), 5) AS AvgOverAllScore
FROM HOTELS H
LEFT JOIN REVIEWS R ON H.HOTEL_ID = R.HOTEL_ID
GROUP BY HOTEL_NAME
ORDER BY AvgOverAllScore DESC;

-- Top 5 hotels by overall score
SELECT TOP 5 HOTEL_NAME, ROUND(AVG(SCORE_OVERALL), 5) AS AvgOverAllScore
FROM HOTELS H
LEFT JOIN REVIEWS R ON H.HOTEL_ID = R.HOTEL_ID
GROUP BY HOTEL_NAME
ORDER BY AvgOverAllScore DESC;

-- Average scores per hotel per aspect
SELECT HOTEL_NAME,
       ROUND(AVG(SCORE_CLEANLINESS),5) AS SCORE_CLEANLINESS,
       ROUND(AVG(SCORE_COMFORT),5) AS SCORE_COMFORT,
       ROUND(AVG(SCORE_FACILITIES),5) AS SCORE_FACILITIES,
       ROUND(AVG(SCORE_LOCATION),5) AS SCORE_LOCATION,
       ROUND(AVG(SCORE_STAFF),5) AS SCORE_STAFF,
       ROUND(AVG(SCORE_VALUE_FOR_MONEY),5) AS SCORE_VALUE_FOR_MONEY
FROM HOTELS H
JOIN REVIEWS R ON H.HOTEL_ID = R.HOTEL_ID
GROUP BY HOTEL_NAME;

-- Average scores by age group
SELECT AGE_GROUP, ROUND(AVG(SCORE_OVERALL),5) AS AvgOverAllScore
FROM USERS U
JOIN REVIEWS R ON U.USER_ID = R.USER_ID
GROUP BY AGE_GROUP
ORDER BY AvgOverAllScore DESC;

-- Average scores by gender
SELECT USER_GENDER, ROUND(AVG(SCORE_OVERALL),5) AS AvgOverAllScore
FROM USERS U
JOIN REVIEWS R ON U.USER_ID = R.USER_ID
GROUP BY USER_GENDER
ORDER BY AvgOverAllScore DESC;

-- Average overall score by country and city
SELECT COUNTRY, CITY, ROUND(AVG(SCORE_OVERALL),5) AS AvgOverAllScore
FROM HOTELS H
JOIN REVIEWS R ON H.HOTEL_ID = R.HOTEL_ID
GROUP BY COUNTRY, CITY
ORDER BY AvgOverAllScore DESC;

-- ========================================
-- TREND ANALYSIS
-- ========================================
-- Number of reviews per year
SELECT YEAR(REVIEW_DATE) AS REVIEW_YEAR, COUNT(*) AS NUMOFREVIEWS
FROM REVIEWS
GROUP BY YEAR(REVIEW_DATE)
ORDER BY REVIEW_YEAR;

-- Number of reviews per month
SELECT DATENAME(MONTH, REVIEW_DATE) AS REVIEW_MONTH, COUNT(*) AS NUMOFREVIEWS
FROM REVIEWS
GROUP BY DATENAME(MONTH, REVIEW_DATE)
ORDER BY REVIEW_MONTH DESC;

-- ========================================
-- BASE RATING VS ACTUAL RATING
-- ========================================
SELECT HOTEL_NAME, star_rating,
       ROUND(AVG(SCORE_OVERALL),5) AS ACTUALRATING,
       (ROUND(AVG(SCORE_OVERALL),5)-star_rating) AS DIFF
FROM HOTELS H 
JOIN REVIEWS R ON H.HOTEL_ID = R.HOTEL_ID 
GROUP BY HOTEL_NAME, star_rating
ORDER BY DIFF DESC;

-- ========================================
-- SCORE DISTRIBUTION PER ASPECT
-- ========================================
SELECT 
    ROUND(AVG(score_cleanliness),2) AS avg_cleanliness,
    ROUND(AVG(score_comfort),2) AS avg_comfort,
    ROUND(AVG(score_facilities),2) AS avg_facilities,
    ROUND(AVG(score_location),2) AS avg_location,
    ROUND(AVG(score_staff),2) AS avg_staff,
    ROUND(AVG(score_value_for_money),2) AS avg_value_for_money
FROM reviews;
