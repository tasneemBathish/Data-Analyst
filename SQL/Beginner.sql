# lightning icon (third icon) execute all statements in the file 
# lightning icon (fourth icon) execute the statements where the cursor is or the highlighted statement
# the limit to 1000 rows i can change or don't limit depends on rows in dbtable

# It is better to write the dbname.dbtable after FROM
# if i don't want to write dbname i can double click on it from schemas on the left
SELECT * FROM parks_and_recreation.employee_demographics;

# If i want to select multible things it is better to make every thing in a line 
SELECT first_name,
last_name,
age
FROM parks_and_recreation.employee_demographics;

# Math 
# PEMDAS (Parentheses() Exponents^ Multiplication* Division/ Addition+ Subtraction-)
SELECT first_name,
last_name,
age,
(age+10)*100+5
FROM parks_and_recreation.employee_demographics;

# DISTINCT to not repeating values just unique values shown
SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;

# not repeating the 2 values togather 
SELECT DISTINCT first_name,
gender
FROM parks_and_recreation.employee_demographics;

# where is used for filtering i can use with strings or int or date
# > greater than 
# >= greater than or equal to
# < smaller than
# <= smaller than or equal to
# != not equal to
# = equal to but in this i must use qutation arround the value if it is not int
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE age = '40';

# date is yyyy-mm-dd
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1985-01-01';

# logical operators AND OR NOT
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE age > 40 
OR NOT gender = 'Male';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55;

# LIKE is used for not exact match but = is used for exact match
# i use % for enything 
# i used _ for one charachter
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name = 'Leslie';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE '%L%';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'a__';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date LIKE '1980%';

# GROUP BY something must select it 
# Aggregate calculations : AVG MAX MIN COUNT
SELECT gender,
AVG(age),
MAX(age),
MIN(age),
COUNT(age)
FROM employee_demographics
GROUP BY gender;

#ORDER BY is used to order ascending(123) by default or discending(321)
SELECT *
FROM employee_demographics
ORDER BY first_name;

SELECT *
FROM employee_demographics
ORDER BY first_name DESC;

# i can also order by multiple things in order
SELECT *
FROM employee_demographics
ORDER BY gender , age;

# i can also order by depends the column position not the name of the column but not recommended
SELECT *
FROM employee_demographics
ORDER BY 5 , 4;

# HAVING is used after group by to filtering the values rather than where
SELECT gender,
AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

# HAVING used to filtering aggregate function after group by
# WHERE used to filtering on the row level 
SELECT occupation,
AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;

# LIMIT show the top rows depends on the number after it
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 4;

# when i use 2 numbers after LIMIT this means that 
# the first number is start position
# the second number is the numer of rows after it 
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3,1;

# ALIASING is used to change the name of the column by using as or just typing the new name
SELECT gender,
AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;

SELECT gender,
AVG(age) avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;
