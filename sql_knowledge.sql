
-- -------------------------------------------------- BASIC SQL -------------------------------------------------- --

-- Using SELECT, FROM, WHERE, AND, OR

SELECT 
    first_name, last_name
FROM
    employees;

SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis' AND gender = 'M';

-- Operator precedence

SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND (first_name = 'Kellie'
        OR first_name = 'Aruna');

-- IN - NOT IN, LIKE - NOT LIKE, wildcard characters, BETWEEN - AND, IS NULL - IS NOT NULL, other comparisons 

SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Cathie' , 'Mark', 'Nathan');
    
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('Mar%');

-- Wildcard characters

SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('%jack%');

SELECT 
    *
FROM
    employees
WHERE
    emp_no NOT BETWEEN '10004' AND '10012';
    
SELECT 
    dept_name
FROM
    departments
WHERE
    dept_no IS NOT NULL;
    
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND hire_date >= '2000-01-01';

-- SELECT DISTINCT, aggregate functions, ORDER BY, GROUP BY, AS, HAVING

SELECT DISTINCT
    gender
FROM
    employees;
    
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= '100,000';
    
SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;

SELECT 
    first_name, COUNT(first_name)
FROM
    employees
GROUP BY first_name
ORDER BY first_name DESC;

SELECT 
    salary, COUNT(salary) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > '80000'
GROUP BY salary
ORDER BY salary;

SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
HAVING COUNT(first_name) > 250
ORDER BY first_name;

SELECT 
    emp_no, COUNT(emp_no) AS no_contracts
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(emp_no) > 1
ORDER BY emp_no;

-- LIMIT, COUNT, SUM, MIN, MAX, AVG, ROUND

SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
WHERE
    hire_date > '1991-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < 200
ORDER BY first_name
LIMIT 100;

SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;
    
SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    
SELECT 
    MIN(salary), MAX(salary), AVG(salary)
FROM
    salaries;
    
SELECT 
    ROUND(AVG(salary),2)
FROM
    salaries
WHERE
	from_date>'1997-01-01';

-- -------------------------------------------------- JOINS -------------------------------------------------- --

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

SELECT 
    e.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM
    employees e
        JOIN
    dept_manager d ON e.emp_no = d.emp_no
ORDER BY e.hire_date;

-- Removing duplicates from 2 tables

DELETE FROM dept_manager_dup
WHERE emp_no = '110228';
 
DELETE FROM departments_dup
WHERE dept_no = 'd009';

# Adding back initial records

INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');
 
INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');

-- And then joining 

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

/* Joining the 'employees' and the 'dept_manager' tables to return a subset of all the employees 
whose last name is Markovitch. See if the output contains a manager with that name. */

SELECT 
    e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager d ON e.emp_no = d.emp_no
WHERE
    last_name = 'Markovitch'
ORDER BY d.dept_no DESC, e.emp_no;

-- RIGHT JOIN

SELECT 
    d.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        RIGHT JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY dept_no;

-- Using JOIN and WHERE

SELECT 
    e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    first_name = 'Margareta'
        AND last_name = 'Markovitch'
ORDER BY e.emp_no;

-- CROSS JOIN

SELECT 
    dm.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
WHERE
    d.dept_no = 'd009'
ORDER BY d.dept_name;

SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;

-- Joins with aggragate functions

SELECT 
    e.gender, AVG(s.salary) AS Average_Salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.gender;

SELECT 
    d.dept_name as department, AVG(salary) as average_salary
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
having average_salary > 60000
ORDER BY average_salary DESC;

-- Joining more than 2 tables

SELECT 
    e.first_name, e.last_name, e.hire_date, t.title, m.from_date, d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;

-- UNION

SELECT 
    e.emp_no, e.first_name, e.last_name, NULL AS dept_no, NULL AS from_date
FROM
    employees_dup e
WHERE
    e.emp_no = 10001 
UNION  SELECT 
    NULL AS emp_no, NULL AS first_name, NULL AS last_name, m.dept_no, m.from_date
FROM
    dept_manager m;
    
-- -------------------------------------------------- ADVANCED SQL -------------------------------------------------- --

-- -------------------------------------------------- Subqueries -------------------------------------------------- --
-- IN embedded inside WHERE

SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            
-- EXISTS - NOT EXISTS

SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND t.title = 'Assistant Engineer')
ORDER BY emp_no;

-- Creating a new table called ‘emp_manager’

DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

-- Filling the table with employees information

INSERT INTO emp_manager 
SELECT
U.*
FROM
	(
	SELECT 
		A.*
	FROM
		(
        SELECT 
			e.emp_no AS employee_ID,
				MIN(de.dept_no) AS deptartment_code,
				(
                SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110022
				) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no <= 10020
		GROUP BY e.emp_no
		ORDER BY e.emp_no) AS A 
	UNION SELECT 
		B.*
	FROM
		(SELECT 
			e.emp_no AS employee_ID,
				MIN(de.dept_no) AS deptartment_code,
				(SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110039) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no > 10020
		GROUP BY e.emp_no
		ORDER BY e.emp_no
		LIMIT 20) AS B    
	UNION SELECT 
		C.*
	FROM
		(SELECT 
			e.emp_no AS employee_ID,
				MIN(de.dept_no) AS deptartment_code,
				(SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110039) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no = 110022
		GROUP BY e.emp_no
		ORDER BY e.emp_no) AS C 
	UNION SELECT 
		D.*
	FROM
		(SELECT 
			e.emp_no AS employee_ID,
				MIN(de.dept_no) AS deptartment_code,
				(SELECT 
						emp_no
					FROM
						dept_manager
					WHERE
						emp_no = 110022) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no = 110039
		GROUP BY e.emp_no
		ORDER BY e.emp_no) AS D ) AS U;

-- -------------------------------------------------- Stored Procedures -------------------------------------------------- --

USE employees;

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$

CREATE PROCEDURE select_employees()
BEGIN
			SELECT * FROM employees
			LIMIT 1000;
END $$

DELIMITER ;

-- Invoking the procedure

CALL employees.select_employees();

-- Average salary procedure

USE employees;

DROP PROCEDURE IF EXISTS average_salary;

DELIMITER $$

CREATE PROCEDURE average_salary()
BEGIN
			SELECT avg(salary) FROM salaries;
END $$

DELIMITER ;

-- Ways to invoke it

CALL avg_salary;
CALL avg_salary();
CALL employees.avg_salary;
CALL employees.avg_salary();

-- Stores procedures with an input

USE employees;
DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
SELECT
	e.first_name, e.last_name, s.salary, s.from_date, s.to_date
FROM employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
END $$

DELIMITER ;

CALL emp_salary(10001);

-- Stored procedures with an input and output

-- Find out the average salary of an employee by typing the employee number

USE employees;
DROP PROCEDURE IF EXISTS emp_avg_salary_out;

DELIMITER $$
CREATE PROCEDURE emp_avg_salary_out(in p_emp_no INTEGER, out p_avg_salary DECIMAL(10,2))
BEGIN
SELECT
	AVG(s.salary)
INTO p_avg_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
END $$

DELIMITER ;

USE employees;
DROP PROCEDURE IF EXISTS emp_info;

-- To find the employee number with the name as an input

DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
	SELECT
		e.emp_no
	INTO p_emp_no FROM
		employees e
    WHERE
        e.first_name = p_first_name
			AND e.last_name = p_last_name;
END$$

DELIMITER ;

-- Variables

SET @v_avg_salary = 0;
CALL employees.emp_avg_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;

SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;

-- -------------------------------------------------- Functions -------------------------------------------------- --

-- To retrieve the latest salary of an employee

USE employees;
DROP FUNCTION IF EXISTS emp_info;

DELIMITER $$
CREATE FUNCTION emp_info (p_first_name varchar(255), p_last_name varchar(255)) RETURNS DECIMAL(10,2)
deterministic
BEGIN

DECLARE v_max_from_date DATE;
DECLARE v_salary DECIMAL(10,2);

	SELECT
		MAX(from_date)
	INTO v_max_from_date FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
		WHERE
		e.first_name = p_first_name
			AND e.last_name = p_last_name;

    SELECT
		s.salary
	INTO v_salary FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
		WHERE
		e.first_name = p_first_name
			AND e.last_name = p_last_name
			AND s.from_date = v_max_from_date;
				RETURN v_salary;

END$$

DELIMITER ;

SELECT EMP_INFO('Aruna', 'Journel');

-- To retrieve the average salary of an employee

USE employees;
DROP FUNCTION IF EXISTS f_emp_avg_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN

DECLARE v_avg_salary DECIMAL(10,2);

SELECT
	AVG(s.salary)
INTO v_avg_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
    
RETURN v_avg_salary;
END $$

DELIMITER ;

SELECT f_emp_avg_salary(11300);

-- -------------------------------------------------- CASE Statement -------------------------------------------------- --

-- Calculating the salary difference and adding a column with the CASE Statement

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS SalaryDifference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'Salary was raised by more than $20,000 but less than $30,000'
        ELSE 'Salary was raised less than $20,000'
    END AS salary_increase
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no
ORDER BY salarydifference;

-- Checking if the employee is still employed in the company

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;

-- SQL scripts using the employess database available from 
-- https://dev.mysql.com/doc/employee/en/employees-preface.html

-- SQL skills learned from the course The Business Intelligence Analyst Course 2021
-- https://www.udemy.com/course/the-business-intelligence-analyst-course-2018/