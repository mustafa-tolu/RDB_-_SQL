USE NYCTaxiData;

/* 
1- Most expensive trip (total amount)
*/

SELECT	TOP 1 *
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
ORDER BY Total_amount DESC

/*
2- Most expensive trip per mile (total amount/mile)
*/

SELECT	MAX(Total_amount/Trip_distance) trip_per_mile
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	Trip_distance != 0 AND Total_amount != 0

/*
3- Most generous trip (highest tip)
*/

SELECT	TOP 1 *
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
ORDER BY Tip_amount DESC
;

/*
4- Longest trip duration
*/

SELECT	TOP 1 *, DATEDIFF(MINUTE, lpep_pickup_datetime, Lpep_dropoff_datetime) trip_dur
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
ORDER BY trip_dur DESC
;
--
select max(DATEDIFF(ms, lpep_pickup_datetime ,Lpep_dropoff_datetime))
from nyc_sample_data_for_sql_sep_2015

/*
5- Mean tip by hour
*/

SELECT	DATEPART(HOUR, lpep_pickup_datetime) trip_hours, ROUND(AVG(Tip_amount), 1) hourly_mean_tip
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
GROUP BY DATEPART(HOUR, lpep_pickup_datetime)
ORDER BY trip_hours
;
--
select distinct datepart(hh,lpep_pickup_datetime), round(avg(Tip_amount) OVER (PARTITION by  datepart(hh,lpep_pickup_datetime)),2,2)
from nyc_sample_data_for_sql_sep_2015
order by 1

/*
6- Median trip cost (This question is optional. You can search for “median” calculation if you want)
*/

/*
7- Average total trip by day of week 
(Fortunately, we have day of week information. 
Otherwise, we need to create a new date column without hours from date column. 
Then, we need to create "day of week" column, i.e Monday, Tuesday .. or 1, 2 ..,  from that new date column. 
Total trip count should be found for each day, lastly average total trip should be calculated for each day)
*/

WITH T2 AS
(
SELECT	CAST(lpep_pickup_datetime AS DATE) everyday, lpep_pickup_day_of_week, COUNT(trip_id) trips_cnt_dow
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
GROUP BY CAST(lpep_pickup_datetime AS DATE), lpep_pickup_day_of_week
)
SELECT lpep_pickup_day_of_week, AVG(trips_cnt_dow) avg_trips
FROM T2
GROUP BY lpep_pickup_day_of_week
;
--
select day_of_week, avg(tot_trip)
from (select distinct cast(lpep_pickup_datetime as date) date_
    ,DATENAME(dw, lpep_pickup_datetime) day_of_week
    ,count(trip_id) over(PARTITION by DATEPART(dd, lpep_pickup_datetime)) tot_trip
from nyc_sample_data_for_sql_sep_2015) cnt
GROUP by day_of_week

/*
8- Count of trips by hour 
(Luckily, we have hour column. Otherwise, a new hour column should be created from date column, then count trips by hour)
*/

SELECT	lpep_pickup_hour, COUNT(trip_id) trip_cnt
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
GROUP BY lpep_pickup_hour
ORDER BY lpep_pickup_hour
;
--
select distinct DATEPART(hh, lpep_pickup_datetime),count(trip_id) OVER(PARTITION by datepart(hh,lpep_pickup_datetime))
from nyc_sample_data_for_sql_sep_2015

/*
9- Average passenger count per trip
*/

SELECT	AVG(CAST(Passenger_count as FLOAT)) avg_passenger
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
;

/*
10- Average passenger count per trip by hour
*/

SELECT	lpep_pickup_hour, AVG(CAST(Passenger_count as FLOAT)) hourly_avg_passenger
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
GROUP BY lpep_pickup_hour
ORDER BY lpep_pickup_hour
;

/*
11- Which airport welcomes more passengers: JFK or EWR? 
Tip: check RateCodeID from data dictionary for the definition (2: JFK, 3: Newark)
*/

SELECT RateCodeID, passengers
FROM 
	(
	SELECT	RateCodeID, SUM(Passenger_count) OVER(PARTITION BY RateCodeID) passengers
	FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
	WHERE	RateCodeID = 2 OR RateCodeID = 3
	) T2
GROUP BY RateCodeID, passengers
;

--
select distinct 
    case when RateCodeID = '1' then 'Standart Rate'
        when RateCodeID = '2' then 'JFK'
        when RateCodeID = '3' then 'Newark'
        when RateCodeID = '4' then 'Nassau or Westchester'
        when RateCodeID = '5' then 'Negoatiated Fare'
        when RateCodeID = '6' then 'Group Ride'
    end as RateCodeID,sum(Passenger_count) OVER(PARTITION by RateCodeID)
from nyc_sample_data_for_sql_sep_2015
where RateCodeID = 2 or RateCodeID = 3

/*
12- How many nulls are there in Total_amount
*/

SELECT	COUNT(Total_amount) total_amount_nulls
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	Total_amount IS NULL

--
select sum(case when Total_amount is null then 1 else 0 end) count_nulls
from nyc_sample_data_for_sql_sep_2015

/*
13- How many values are there in Trip_distance? 
	(count of non-missing values)
*/

SELECT	COUNT(Trip_distance) trip_dist_count
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	Trip_distance IS NOT NULL
;

--
select sum(case when Trip_distance is not null then 1 else 0 end)
from nyc_sample_data_for_sql_sep_2015

/*
14- How many nulls are there in Ehail_fee
*/

SELECT	COUNT(Ehail_fee) ehail_fee_count
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	Ehail_fee IS NULL
;

/*
15- Find the trips of which trip distance is greater than 15 miles (included) or less than 0.1 mile (included). 
	It is possible to write this with only one where statement. However, this time write two queries and "union" them. 
	The purpose of this question is to use union function. 
	You can consider this question as finding outliers in a quick and dirty way, which you would do in your professional life too often
*/

SELECT	*
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	Trip_distance >= 15
UNION
SELECT	*
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	Trip_distance <= 0.1

/*
16- We would like to see the distribution (not like histogram) of Total_amount. 
	Could you create buckets, or price range, for Total_amount and find how many trips there are in each buckets? 
	Each range would be 5, until 35, i.e. 0-5, 5-10, 10-15 … 30-35, +35
*/

SELECT	payment_range, COUNT(trip_id) number_of_trips
FROM	
	(
	SELECT	
			CASE
				WHEN Total_amount <= 5 THEN '0-5'
				WHEN Total_amount > 5 AND Total_amount <= 10 THEN  '5-10'			
				WHEN Total_amount > 10 AND Total_amount <= 15 THEN '10-15'
				WHEN Total_amount > 15 AND Total_amount <= 20 THEN '15-20'
				WHEN Total_amount > 20 AND Total_amount <= 25 THEN '20-25'
				WHEN Total_amount > 25 AND Total_amount <= 30 THEN '25-30'
				WHEN Total_amount > 30 AND Total_amount <= 35 THEN '30-35'
				WHEN Total_amount > 35 THEN '35+'
				END AS payment_range, trip_id
	FROM		[dbo].[nyc_sample_data_for_sql_sep_2015]
	) pr_ta
GROUP BY	payment_range
ORDER BY	1
;

/*
17- We also would like to analyze the performance of each driver’s earning. 
	Could you add driver_id to payment distribution table?  
*/

SELECT	driver_id, payment_range, COUNT(trip_id) number_of_trips
FROM	
	(
	SELECT	driver_id,
			CASE
				WHEN Total_amount <= 5 THEN '0-5'
				WHEN Total_amount > 5 AND Total_amount <= 10 THEN  '5-10'			
				WHEN Total_amount > 10 AND Total_amount <= 15 THEN '10-15'
				WHEN Total_amount > 15 AND Total_amount <= 20 THEN '15-20'
				WHEN Total_amount > 20 AND Total_amount <= 25 THEN '20-25'
				WHEN Total_amount > 25 AND Total_amount <= 30 THEN '25-30'
				WHEN Total_amount > 30 AND Total_amount <= 35 THEN '30-35'
				WHEN Total_amount > 35 THEN '35+'
				END AS payment_range, trip_id
	FROM		[dbo].[nyc_sample_data_for_sql_sep_2015]
	) pr_ta
GROUP BY	driver_id, payment_range
ORDER BY	1, 2
;

/*
18- Could you find the highest 3 Total_amount trips for each driver? 
	Use “Window” functions
*/

SELECT	driver_id, Total_amount
FROM
	(
	SELECT	RANK() OVER(PARTITION BY driver_id ORDER BY Total_amount DESC) top_3_rank, Total_amount, driver_id
	FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
	) T1
WHERE	top_3_rank <= 3
;

/*
19- Could you find the lowest 3 Total_amount trips for each driver? 
	Use “Window” functions
*/

SELECT	driver_id, Total_amount
FROM
	(
	SELECT	RANK() OVER(PARTITION BY driver_id ORDER BY Total_amount) top_3_rank, Total_amount, driver_id
	FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
	) T1
WHERE	top_3_rank <= 3
;

/*
20- Could you find the lowest 10 Total_amount trips for driver_id 1? 
	Do you see any anomaly in the rank? (same rank, missing rank etc). 
	Could you “fix” that so that ranking would be 1, 2, 3, 4… (without any missing rank)? 
	Note that 1 is the lowest Total_amount in this question. Also, same ranks would continue to exist since there might be the same Total_amount. 
	Hint: dense_rank
*/

SELECT	*
FROM
	(
	SELECT	DENSE_RANK() OVER(PARTITION BY driver_id ORDER BY Total_amount) top_10_rank, Total_amount, driver_id
	FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
	) T1
WHERE	driver_id = 1 
AND		top_10_rank <= 10
;

--
select distinct top 10 Total_amount
from nyc_sample_data_for_sql_sep_2015
where driver_id = 1
order by Total_amount asc

/*
21- driver_id 1, is very happy to see what we have done for her 
	(Yes, it is “her”. Her name is Gertrude Jeannette, https://en.wikipedia.org/wiki/Gertrude_Jeannette. That is why her id is 1). 
	Could you do her a favor and track her earning after each trip? She would be very thankful
	Hint: Cumulative sum, running total
*/

SELECT	lpep_pickup_datetime, Total_amount, Passenger_count, 
		SUM(Total_amount) OVER(ORDER BY lpep_pickup_datetime) Cumulative_Sum
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	driver_id = 1
;

-- !!! CHECK TOTAL AMOUNT COLUMN

/*
22- Gertrude is fascinated by your work and would like you to find max and min Total_amount. 
*/
SELECT	*
FROM
	(
	SELECT	TOP 1 lpep_pickup_datetime, Total_amount, Passenger_count
	FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
	WHERE	driver_id = 1
	ORDER BY Total_amount
	) min_total
UNION ALL
SELECT	*
FROM
	(
	SELECT	TOP 1 lpep_pickup_datetime, Total_amount, Passenger_count
	FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
	WHERE	driver_id = 1
	ORDER BY Total_amount DESC
	) max_total
;
--
SELECT	lpep_pickup_datetime, Total_amount, Passenger_count
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
WHERE	Total_amount = (select min(Total_amount) from nyc_sample_data_for_sql_sep_2015 where driver_id = 1)
OR		Total_amount = (select max(Total_amount) from nyc_sample_data_for_sql_sep_2015 where driver_id = 1)
;


/*
23- There is one thing that Gertrude could not understand. 
	Min Total_amount is 0, however we did not show any 0 while we track her earning (in cumulative sum question). 
	It seems we owe her an explanation. Why do you think this happened?
*/

/*
Answer: :D
*/

----
-- October !
/*
24- Is there any new driver in October? 
	Hint: Drivers existing in one table but not in another table
*/

SELECT	driver_id
FROM	[dbo].[nyc_sample_data_for_sql_oct_2015]
EXCEPT
SELECT	driver_id
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]

/*
25- Total amount difference between October and September.
*/

SELECT
(
SELECT	SUM(Total_amount)
FROM	[dbo].[nyc_sample_data_for_sql_oct_2015]
)
-
(
SELECT	SUM(Total_amount)
FROM	[dbo].[nyc_sample_data_for_sql_sep_2015]
)

/*
26- Revenue of drivers each month (Find the difference revenue by each driver for two months)
*/

SELECT	O.driver_id, O.Total_amount_oct, S.Total_amount_sep, (O.Total_amount_oct-S.Total_amount_sep) oct_sep_revenue_diff
FROM
	(SELECT driver_id, SUM(Total_amount) Total_amount_oct FROM [dbo].[nyc_sample_data_for_sql_oct_2015] GROUP BY driver_id) O 
	RIGHT JOIN
	(SELECT driver_id, SUM(Total_amount) Total_amount_sep FROM [dbo].[nyc_sample_data_for_sql_sep_2015] GROUP BY driver_id) S 
	ON O.driver_id = S.driver_id
ORDER BY O.driver_id

/*
27- Trip count of drivers each month
*/

SELECT O.driver_id, O.Trip_cnt_oct, S.Trip_cnt_sep, (O.Trip_cnt_oct-S.Trip_cnt_sep) oct_sep_revenue_diff
FROM
	(SELECT driver_id, COUNT(trip_id) Trip_cnt_oct FROM [dbo].[nyc_sample_data_for_sql_oct_2015] GROUP BY driver_id) O 
	RIGHT JOIN
	(SELECT driver_id, COUNT(trip_id) Trip_cnt_sep FROM [dbo].[nyc_sample_data_for_sql_sep_2015] GROUP BY driver_id) S 
	ON O.driver_id = S.driver_id
ORDER BY O.driver_id

/*
28- Revenue_per-trip of drivers each month
*/

SELECT	O.driver_id, O.revenue_per_trip_oct, S.revenue_per_trip_sep, ROUND((O.revenue_per_trip_oct-S.revenue_per_trip_sep), 2) oct_sep_revenue_per_trip_diff
FROM
	(SELECT driver_id, ROUND(AVG(Total_amount), 2) revenue_per_trip_oct FROM [dbo].[nyc_sample_data_for_sql_oct_2015] GROUP BY driver_id) O 
	RIGHT JOIN
	(SELECT driver_id, ROUND(AVG(Total_amount), 2) revenue_per_trip_sep FROM [dbo].[nyc_sample_data_for_sql_sep_2015] GROUP BY driver_id) S 
	ON O.driver_id = S.driver_id
ORDER BY O.driver_id
;

/*
29- Revenue per day of week comparison
*/

SELECT	O.lpep_pickup_day_of_week, O.Total_amount_oct, S.Total_amount_sep, (O.Total_amount_oct-S.Total_amount_sep) oct_sep_revenue_diff
FROM
	(SELECT lpep_pickup_day_of_week, SUM(Total_amount) Total_amount_oct FROM [dbo].[nyc_sample_data_for_sql_oct_2015] GROUP BY lpep_pickup_day_of_week) O 
	RIGHT JOIN
	(SELECT lpep_pickup_day_of_week, SUM(Total_amount) Total_amount_sep FROM [dbo].[nyc_sample_data_for_sql_sep_2015] GROUP BY lpep_pickup_day_of_week) S 
	ON O.lpep_pickup_day_of_week = S.lpep_pickup_day_of_week
ORDER BY O.lpep_pickup_day_of_week

/*
30- Revenue per day of week for each driver comparison
*/

SELECT O.driver_id, O.lpep_pickup_day_of_week, O.Total_amount_oct, S.Total_amount_sep, (total_amount_oct-total_amount_sep) oct_sep_revenue_diff
FROM
	(SELECT DISTINCT	driver_id, lpep_pickup_day_of_week, SUM(Total_amount) OVER(PARTITION BY driver_id, lpep_pickup_day_of_week) total_amount_oct FROM [dbo].[nyc_sample_data_for_sql_oct_2015]) O 
	RIGHT JOIN
	(SELECT DISTINCT	driver_id, lpep_pickup_day_of_week, SUM(Total_amount) OVER(PARTITION BY driver_id, lpep_pickup_day_of_week) total_amount_sep FROM [dbo].[nyc_sample_data_for_sql_sep_2015]) S 
	ON O.lpep_pickup_day_of_week = S.lpep_pickup_day_of_week
	AND O.driver_id = S.driver_id

/*
31- Revenue and trip count comparison of VendorID. 
	You can also add passenger count, trip mile etc as a practice for yourself
*/

SELECT	O.VendorID, O.Total_amount_oct, S.Total_amount_sep, (total_amount_oct-total_amount_sep) oct_sep_revenue_diff, 
		O.trip_count_oct, trip_count_sep, (O.trip_count_oct-S.trip_count_sep) trip_count_diff
FROM
	(SELECT DISTINCT	VendorID,
						SUM(Total_amount) OVER(PARTITION BY VendorID) total_amount_oct,
						COUNT(trip_id) OVER(PARTITION BY VendorID) trip_count_oct
	FROM [dbo].[nyc_sample_data_for_sql_oct_2015]) O 
	INNER JOIN
	(SELECT DISTINCT	VendorID, 
						SUM(Total_amount) OVER(PARTITION BY VendorID) total_amount_sep,
						COUNT(trip_id) OVER(PARTITION BY VendorID) trip_count_sep
	FROM [dbo].[nyc_sample_data_for_sql_sep_2015]) S 
	ON  O.VendorID = S.VendorID

