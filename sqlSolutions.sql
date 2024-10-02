select * from artist
select * from canvas_size
select * from image_link
select * from museum_hours
select * from museum
select * from product_size
select * from subject
select * from work

-- identify the museums which are open on both Sunday and monday.
-- Display the museums name, city

SELECT m.name, m.city
FROM museum_hours mh
LEFT JOIN museum m ON m.museum_id = mh.museum_id
WHERE mh.day IN ('Sunday', 'Monday')
GROUP BY 1,2
HAVING COUNT(DISTINCT mh.day) = 2;

--which museum is open for the longest during the day
--display museum name, state and hours open and which day

select * from (
select m.name as museum_name, m.state as museum_state, mh.day,
	--to_timestamp (open, 'HH:MI AM') as open_time, CONVERTED TO TIME
	--to_timestamp (close, 'HH:MI AM') as close_time, CONVERTED TO TIME
	to_timestamp (close, 'HH:MI AM') - to_timestamp (open, 'HH:MI AM') as time_diff,
	rank() OVER(order by to_timestamp (close, 'HH:MI AM') - to_timestamp (open, 'HH:MI AM') desc ) as ranked
	from museum_hours mh
	LEFT JOIN museum m 
	ON m.museum_id = mh.museum_id
) x
where x.ranked = 1;

-- Display the country and the city with the most number of museums.
-- outpu two separate columns to mention the city  and the country
-- if there are multiple value separate them with coma

with cte_country as
	(
	select 
		country,count(1),
		rank() over(order by count(1) desc) as rnk
		from museum
		group by country),
	cte_city as
	(
	select 
		city,count(1),
		rank() over(order by count(1) desc) as rnk
		from museum
		group by city)

select string_agg(distinct country, ',') as country, string_agg(city, ',') as city
from cte_country
cross join cte_city
where cte_country.rnk = 1 and cte_city.rnk = 1