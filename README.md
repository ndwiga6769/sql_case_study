# sql_case_study Painting Database and Museum Analysis: README
This README provides an overview of a Python script used to import data from CSV files into a PostgreSQL database, as well as SQL queries to analyze the imported data. The project centers around artwork and museum data, including artist information, canvas sizes, museum hours, and more.

## Python Script: Data Import
### Requirements:
Python Libraries:
pandas: For data manipulation.
sqlalchemy: For database connection and interaction.
psycopg2: PostgreSQL driver for Python.
PostgreSQL Database: A database named painting must be set up in PostgreSQL for the data import.
Connection Setup:
The script establishes a connection to a PostgreSQL database using SQLAlchemy and psycopg2 with the following connection string:

python
conn_string = 'postgresql+psycopg2://postgres:Njoka123#@localhost:5433/painting'
Data Import Process:
The script reads CSV files located in a specified folder and loads them into the PostgreSQL database. The files are:

artist.csv
canvas_size.csv
image_link.csv
museum.csv
museum_hours.csv
product_size.csv
subject.csv
work.csv
For each file, it:

### Reads the CSV into a pandas DataFrame.
Uploads the data to the PostgreSQL database using the to_sql() function.
Code Snippet:
python
files = ['artist', 'canvas_size', 'image_link', 'museum', 'museum_hours', 'product_size', 'subject', 'work']

for file in files:
    df = pd.read_csv(f'C:/path_to_csv/{file}.csv')
    df.to_sql(file, con=conn, if_exists='replace', index=False)
SQL Queries for Analysis
After loading the data, several SQL queries are executed to analyze the museum data.

### 1. Identify Museums Open on Both Sunday and Monday
This query identifies museums that are open on both Sunday and Monday. It lists the museum name and city.

sql
SELECT m.name, m.city
FROM museum_hours mh
LEFT JOIN museum m ON m.museum_id = mh.museum_id
WHERE mh.day IN ('Sunday', 'Monday')
GROUP BY m.name, m.city
HAVING COUNT(DISTINCT mh.day) = 2;
### 2. Museum Open for the Longest Duration
This query identifies the museum that is open for the longest time during the day, listing the museum name, state, and the number of hours open.

sql
SELECT * FROM (
    SELECT m.name AS museum_name, m.state AS museum_state, mh.day,
           TO_TIMESTAMP(close, 'HH:MI AM') - TO_TIMESTAMP(open, 'HH:MI AM') AS time_diff,
           RANK() OVER (ORDER BY TO_TIMESTAMP(close, 'HH:MI AM') - TO_TIMESTAMP(open, 'HH:MI AM') DESC) AS ranked
    FROM museum_hours mh
    LEFT JOIN museum m ON m.museum_id = mh.museum_id
) x
WHERE x.ranked = 1;
### 3. City and Country with the Most Museums
This query identifies the city and country with the most museums. If there are multiple top cities or countries, the results are separated by commas.

sql
WITH cte_country AS (
    SELECT country, COUNT(1), RANK() OVER (ORDER BY COUNT(1) DESC) AS rnk
    FROM museum
    GROUP BY country
),
cte_city AS (
    SELECT city, COUNT(1), RANK() OVER (ORDER BY COUNT(1) DESC) AS rnk
    FROM museum
    GROUP BY city
)
SELECT STRING_AGG(DISTINCT country, ',') AS country, STRING_AGG(city, ',') AS city
FROM cte_country
CROSS JOIN cte_city
WHERE cte_country.rnk = 1 AND cte_city.rnk = 1;
### Conclusion
This project allows you to easily import museum and artwork-related data into a PostgreSQL database using Python. The provided SQL queries offer insights into museum operations, such as which museums are open on specific days, which have the longest hours, and which cities and countries have the most museums.