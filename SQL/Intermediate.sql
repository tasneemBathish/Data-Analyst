# JOIN used to join 2 tables but it must have the same column in each of them
# JOIN = INNER JOIN 
# return rows that have the same value from 2 tables depends on the column name after ON
SELECT *
FROM employee_demographics
JOIN employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id ;
 
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id ;
    
# if the column name is the same from 2 tables i have to choose the table and name it before the column name when i want to select it
SELECT dem.employee_id,age,occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id ;

# LEFT JOIN = LEFT OUTER JOIN
# return evrything in left table even if no match from right table (shows null) 
SELECT *
FROM employee_demographics AS dem  #left table
LEFT JOIN employee_salary AS sal   #right table
	ON dem.employee_id = sal.employee_id ;
    
# RIGHT JOIN = RIGHT OUTER JOIN
# return evrything in right table even if no match from left table (shows null) 
SELECT *
FROM employee_demographics AS dem  #left table
RIGHT JOIN employee_salary AS sal   #right table
	ON dem.employee_id = sal.employee_id ;
    
# SELF JOIN
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id +1 = emp2.employee_id ;
    
# join multiple tables togather 
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id 
INNER JOIN parks_departments AS pd
		ON sal.dept_id = pd.department_id ;
    
# this is reference table (not changed)
SELECT *
FROM parks_departments;

# unions
# used to combine rows togather (combine the rows of data from separate tables)
# by default is UNION DISTINCT
SELECT first_name,last_name
FROM employee_demographics
UNION
SELECT first_name,last_name
FROM employee_salary
;

# if i want all without distinct i use UNION ALL
SELECT first_name,last_name
FROM employee_demographics
UNION ALL
SELECT first_name,last_name
FROM employee_salary
;

SELECT first_name, last_name ,'old man' AS label
FROM employee_demographics
where age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name ,'old lady' AS label
FROM employee_demographics
where age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name ,'highly paid employee' AS label
FROM employee_salary
where salary > 70000 
ORDER BY first_name, last_name;

# strings functions
# LENGTH('') shows the length of that string inside it
# LENGTH used with phone numbers (10 characters long)
SELECT first_name ,LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

# UPPER('') shows the string all characters in uppercase
# LOWER('') shows the string all characters in lowercase
# used for standardization
SELECT first_name ,UPPER(first_name),LOWER(first_name)
FROM employee_demographics;

# TRIM('') remove leading and trailing white spaces
SELECT TRIM('         SKY          ');

# LTRIM('') remove leading white spaces
SELECT LTRIM('         SKY          ');

# RTRIM('') remove trailing white spaces
SELECT RTRIM('         SKY          ');

# LEFT('',NUMBER) show the character from left depends on number i put
# RIGHT('',NUMBER) show the character from right depends on number i put
# SUBSTRING('',POSITION,NUMBER OF CHARACTER I WANT) 
# SUBSTRING used with date
SELECT first_name,
LEFT(first_name,3),
RIGHT(first_name,3),
SUBSTRING(first_name,2,3),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month
FROM employee_demographics;

# REPLACE('',''what i want to replace,''what i want to replace with)
# used to replace charachter with another character
SELECT first_name,REPLACE(first_name,'a','z')
FROM employee_demographics;

# LOCATE(''character i look for,''string where i found the character)
# LOCATE shows the position of the character in the string
SELECT first_name,LOCATE('An',first_name)
FROM employee_demographics;

# CONCAT used to combine multiple columns in one column
SELECT first_name,
last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM employee_demographics;

# case statements used for logic likes to if statements in programming language
SELECT first_name,
last_name,
age,
CASE
	WHEN age <= 30 THEN 'young'
    WHEN age BETWEEN 31 AND 50 THEN 'old'
    WHEN age > 50 THEN 'on death door'
END AS age_bracket
FROM employee_demographics;

-- <50000 =5%
-- >50000 =7%
-- finance = 10% bonus

SELECT first_name,
last_name,
salary,
CASE
	WHEN salary < 50000 THEN salary+(salary*0.05)
    WHEN salary > 50000 THEN salary*1.07
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary*.10
END AS bonus
FROM employee_salary;

# subqueries means that a query within another query
# used in WHERE clause
SELECT *
FROM employee_demographics
WHERE employee_id IN
					(SELECT employee_id  # in this it must be 1 column
                    FROM employee_salary
                    WHERE dept_id = 1)
;

# used in SELECT statement
SELECT first_name,
salary,
(SELECT AVG(salary)
 FROM employee_salary)
FROM employee_salary
;

# used in FROM clause
# here i can select avg of max of age
# if i write AVG(MAX(age)) this show error because there is not a column named age in subquery
SELECT  AVG(max_age)   -- or i can write AVG(`MAX(age)`) without alias
FROM
(SELECT gender,
AVG(age) AS avg_age,
MAX(age) AS max_age,
MIN(age) AS min_age,
COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender)
AS agg_table # i should name it 
;

SELECT gender, AVG(`MAX(age)`) 
FROM
(SELECT gender,
AVG(age) ,
MAX(age) ,
MIN(age) ,
COUNT(age) 
FROM employee_demographics
GROUP BY gender)
AS agg_table # i should name it 
GROUP BY gender
;

# window functions
# it is similar to group by but every single row has his own (the same value repeated in each row)
SELECT dem.first_name,
dem.last_name,
gender,
AVG(salary) OVER (PARTITION BY gender) # if i write OVER() that means over evrything so it shows the avg of all salarys
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

# rolling total means that in every time adding the salary to the previous sum salary
# rolling total starts with a specific value and add on values from subsequence rows based of the partition
SELECT dem.first_name,
dem.last_name,
gender,
salary,
SUM(salary) OVER (PARTITION BY gender  ORDER BY dem.employee_id) AS rolling_total
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

# ROW_NUMBER() this is aggrigate function like AVG 
# used to make random order depends on the partition by and order by
# if it does not have partition it does not duplicate the number even if the value(salary) is the same (unique)

# RANK() duplicate the number if the value(salary) is the same but the next one have the next number positionally (5,5,7)

# DENSE_RANK() duplicate the number if the value(salary) is the same but the next one have the next number numerically (5,5,6)

SELECT dem.employee_id,
dem.first_name,
dem.last_name,
gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;