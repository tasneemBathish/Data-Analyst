# CTE common table expression
# to name subquery block to make it more standardized and readable
# i can only use it immediately after create it
WITH cte_example AS 
(SELECT gender,
AVG(salary) AS avg_sal,
MAX(salary) AS max_sal,
MIN(salary) AS min_sal,
COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM cte_example
;

# if i try to use it hear it will show error because the table is not in the db 
# SELECT AVG(avg_sal)
# FROM cte_example

# this is difficult to read
SELECT AVG(avg_sal)
FROM(
SELECT gender,
AVG(salary) AS avg_sal,
MAX(salary) AS max_sal,
MIN(salary) AS min_sal,
COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery;

# multiple CTEs
WITH cte_example AS 
(
SELECT employee_id,
gender,
birth_date
FROM employee_demographics 
WHERE birth_date > '1985-01-01'
),
cte_example2 AS
(
SELECT employee_id,
salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM cte_example
JOIN cte_example2
	ON cte_example.employee_id = cte_example2.employee_id
;

# aliasing with CTEs
# overwrite the columns names
WITH cte_example (GENDER,AVG_SAL,MAX_SAL,MIN_SAL,COUNT_SAL)AS 
(SELECT gender,
AVG(salary),
MAX(salary),
MIN(salary),
COUNT(salary) 
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM cte_example
;

# temporary tables
# only visible to the session that they are created in 
# so when i exit then return to select from the temporary table it makes error
# used for storing intermediate results for complex queries
# created in the memory not in the db
# first way not popular
CREATE TEMPORARY TABLE temp_table
(first_name VARCHAR(50),
last_name VARCHAR(50),
favorite_movie VARCHAR(100)
);

INSERT INTO temp_table
VALUES('tasneem','bathish','friends');

SELECT *
FROM temp_table;

# second way is popular
CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;

# stored procedures
# used to save sql code so i can reuse 
# storing complex queries and enhancing performance
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

# DELIMITER used to separate different queries like ; by default
# so i can change dilimiter by using $$ or //
DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
# must return dilimiter to ;
DELIMITER ;

CALL large_salaries2();

# parameters in procedure
DELIMITER $$
# to make difference between employee_id in table and employee_id in parameter
# employee_id_pram or p_employee_id
CREATE PROCEDURE salary_of(employee_id_pram INT) 
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = employee_id_pram;
	
END $$
DELIMITER ;

CALL salary_of(1);

# triggers and events
# trigger is block of code that execute automatically when an events takes place on specific table
# bach triggers or table level triggers only trigger once not for each row
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary  # this is the event i can write before or after
    FOR EACH ROW # the trigger activated for each row
BEGIN
	INSERT INTO employee_demographics(employee_id,first_name,last_name)
    VALUES(NEW.employee_id,NEW.first_name,NEW.last_name); # i can use old this takes rows that were deleted or updated
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
VALUES (13,'tasneem','bathish','CEO',100000,NULL);

SELECT *
FROM employee_salary;

SELECT * 
FROM employee_demographics;

# event takes place when it is scheduled
# used when importing data so i can pull data from a specific file path on a schedule
# build reports that are exported to a file on schedule daily,weekly,monthly,yearly

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

SELECT *
FROM employee_demographics
