CREATE TABLE travel_trends_social_data (
    Date DATE,
    Time TIME,
    UserID CHAR(6),
    Location VARCHAR(15),
    PostContent TEXT,
    Sentiment VARCHAR(8),
    Likes INTEGER,
    Comments INTEGER,
    EngagementScore FLOAT,
    ImageDescription TEXT,
    TravelType VARCHAR(10)
);
/* Imported the dataset by using the import data too */

SELECT * FROM travel_trends_social_data LIMIT 10;

------------------------------------------------
/* ANALYSIS */

-- Top 10 Destinations by Total Engagement
SELECT travel_trends_social_data.Location, SUM(travel_trends_social_data.EngagementScore) AS total_engagement
FROM travel_trends_social_data
GROUP BY travel_trends_social_data.Location
ORDER BY total_engagement DESC
LIMIT 10;


-- Average Engagement by Travel Type
SELECT travel_trends_social_data.traveltype, AVG(travel_trends_social_data.EngagementScore) AS avg_engagement, COUNT(*) AS post_count
FROM travel_trends_social_data
GROUP BY travel_trends_social_data.traveltype
ORDER BY avg_engagement DESC;


-- Sentiment by City (Top 10 Featured)
SELECT travel_trends_social_data.location, travel_trends_social_data.Sentiment, COUNT(*) as posts, AVG(travel_trends_social_data.EngagementScore) AS avg_engagement
FROM travel_trends_social_data
GROUP BY travel_trends_social_data.location, travel_trends_social_data.Sentiment
ORDER BY avg_engagement DESC
LIMIT 10;


-- Most Engaging Themes (Image Description Keywords, e.g. "sunset")
SELECT travel_trends_social_data.imagedescription, AVG(travel_trends_social_data.EngagementScore) AS avg_engagement, COUNT(*) AS mentions
FROM travel_trends_social_data
WHERE LOWER(travel_trends_social_data.imagedescription) LIKE '%sunset%'
GROUP BY travel_trends_social_data.imagedescription
ORDER BY avg_engagement DESC
LIMIT 10;


-- Top 10 Influencers by Engagement
SELECT travel_trends_social_data.UserID, COUNT(*) AS posts, SUM(travel_trends_social_data.EngagementScore) AS total_engagement, AVG(travel_trends_social_data.EngagementScore) AS avg_eng
FROM travel_trends_social_data
GROUP BY travel_trends_social_data.UserID
ORDER BY total_engagement DESC
LIMIT 10;


-- Best Time of Day to Post by Engagement
SELECT EXTRACT(HOUR FROM travel_trends_social_data.Time) AS post_hour, AVG(travel_trends_social_data.EngagementScore) AS avg_engagement, COUNT(*) AS posts
FROM travel_trends_social_data
GROUP BY post_hour
ORDER BY avg_engagement DESC;


-- Day-Of-Week Patterns: Post Volume and Engagement
SELECT EXTRACT(DOW FROM travel_trends_social_data.Date) AS dow,
       CASE EXTRACT(DOW FROM travel_trends_social_data.Date)::int
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS weekday_name,
	   COUNT(*) AS post_count,
       AVG(travel_trends_social_data.EngagementScore) AS avg_eng
FROM travel_trends_social_data
GROUP BY dow
ORDER BY dow;


-- Common Sequence Patterns (Travel Loops)
SELECT a.UserID, a.Location, b.Location
FROM travel_trends_social_data a
JOIN travel_trends_social_data b
  ON a.UserID = b.UserID
  AND a.Date < b.Date
GROUP BY a.UserID, a.Location, b.Location
HAVING a.Location <> b.Location
LIMIT 20;
