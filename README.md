# Hotel Reviews Analysis Project

## Project Overview
This project analyzes hotel, user, and review data to generate insights about customer behavior, hotel performance, and review trends. The analysis is conducted using SQL queries on three main tables: `hotels`, `users`, and `reviews`.

## Database Schema

### Hotels
- `hotel_id` (Primary Key)
- `hotel_name`
- `city`
- `country`
- `star_rating`
- `lat`, `lon`
- `cleanliness_base`, `comfort_base`, `facilities_base`, `location_base`, `staff_base`, `value_for_money_base`

### Users
- `user_id` (Primary Key)
- `user_gender`
- `country`
- `age_group`
- `traveller_type`
- `join_date`

### Reviews
- `review_id` (Primary Key)
- `user_id` (Foreign Key → users)
- `hotel_id` (Foreign Key → hotels)
- `review_date`
- `score_overall`, `score_cleanliness`, `score_comfort`, `score_facilities`, `score_location`, `score_staff`, `score_value_for_money`
- `review_text`

## Analysis Performed

### Hotel Counts
- Total hotels, hotels per city and country.

### User Analysis
- Total users, users per gender, country, traveller type, age group.
- Maximum and minimum users per country and traveller type.
- Age distribution per country and overall.

### Reviews Analysis
- Total reviews per hotel.
- Reviews by user gender, age group, traveller type.
- Number of distinct users per hotel.

### Scores Analysis
- Average overall score per hotel.
- Top 5 hotels by overall score.
- Average score per hotel by aspect.
- Average score by age group, gender, city, and country.
- Comparison of base rating vs actual rating.
- Score distribution per aspect.

### Trend Analysis
- Number of reviews per year and per month.

## Insights Generated
- Identify which hotels receive the most positive or negative reviews.
- Determine customer segments providing most reviews and their ratings.
- Detect hotels with high review volume but low scores.
- Analyze trends over time and rating distribution across demographics.

## How to Use
1. Create the `HOTEL_ANALYSIS` database.
2. Load your `hotels`, `users`, and `reviews` data.
3. Run the provided SQL queries to generate descriptive statistics and insights.
4. Use results to guide hotel performance improvement, marketing strategy, or customer satisfaction analysis.

## Tools Used
- SQL Server for database and queries.
- Optional: Python for advanced text analysis or visualization.
