-- Creating tables for PH_EmployeeDB

CREATE TABLE departments(
	dept_no VARCHAR NOT NULL, 
	dept_name VARCHAR(40) NOT NULL, 
	PRIMARY KEY (dept_no), 
	UNIQUE (dept_name)
);

SELECT * FROM departments;

CREATE TABLE employees(
	emp_no INT NOT NULL, 
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL, 
	last_name VARCHAR NOT NULL, 
	gender VARCHAR NOT NULL, 
	hire_date DATE NOT NULL, 
	PRIMARY KEY (EMP_NO)
);

SELECT * FROM employees;

CREATE TABLE dept_manager(
	dept_no VARCHAR NOT NULL, 
	emp_no INT NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL, 
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no), 
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no), 
	PRIMARY KEY (emp_no, dept_no)
); 

SELECT * FROM dept_manager;

CREATE TABLE salaries(
	emp_no INT NOT NULL, 
	salary INT NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL, 
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

SELECT * FROM salaries;

CREATE TABLE dept_emp(
	emp_no INT NOT NULL, 
	dept_no VARCHAR NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no), 
	PRIMARY KEY (emp_no, dept_no)
); 

SELECT * FROM dept_emp;

CREATE TABLE titles(
	emp_no INT NOT NULL, 
	title VARCHAR(50) NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE, 
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no), 
	PRIMARY KEY (emp_no, title, from_date)
); 

SELECT * FROM titles;

DROP TABLE departments CASCADE; 
DROP TABLE dept_emp CASCADE; 

COPY departments FROM '/Users/harrisonpreston/Public/departments.csv' DELIMITER ',' CSV HEADER;
COPY employees FROM '/Users/harrisonpreston/Public/employees.csv' DELIMITER ',' CSV HEADER; 
COPY dept_manager FROM '/Users/harrisonpreston/Public/dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM '/Users/harrisonpreston/Public/salaries.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM '/Users/harrisonpreston/Public/dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY titles FROM '/Users/harrisonpreston/Public/titles.csv' DELIMITER ',' CSV HEADER;


-- Determine Retirement Eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create a table for employees who may be retiring
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the Table
SELECT * FROM retirement_info

-- Drop retirement_info table in order to make adjustments
DROP TABLE retirement_info; 

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Join retirement_info and dept_emp into a new table
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_by_department
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM retirement_by_department;

-- List 1: employee information

SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
	INNER JOIN salaries as s
		ON (e.emp_no = s.emp_no)
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info; 

-- List 2: Management
-- List of managers per department

SELECT dm.dept_no, 
		d.dept_name, 
		dm.emp_no, 
		ce.last_name,
		ce.first_name,
		dm.from_date,
		dm.to_date
INTO manager_info
FROM dept_manager as dm
	INNER JOIN departments as d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp as ce
		ON (dm.emp_no = ce.emp_no);

SELECT * FROM manager_info;

-- List 3: Department Retirees

SELECT ce.emp_no, 
		ce.first_name, 
		ce.last_name, 
		d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)

SELECT * FROM dept_info; 

-- Creating retirement info for sales department
SELECT *
INTO sales_info
FROM dept_info 
WHERE dept_name = 'Sales';

SELECT * FROM sales_info;

-- Creating retirement info for sales and development departments
SELECT *
INTO sales_development_info
FROM dept_info 
WHERE dept_name IN ('Sales', 'Development')

SELECT * FROM sales_development_info;

-- MODULE 7 CHALLENGE
-- Deliverable 1

SELECT  
    t.title,
	e.first_name, 
	e.last_name,
	t.from_date,
	t.to_date,
	s.salary,
	e.emp_no
INTO retiring_info_challenge
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
	INNER JOIN salaries as s
		ON (e.emp_no = s.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
GROUP BY 1, 2, 3, 4, 5, 6, 7

-- Partition the data to show only most recent title per employee
SELECT 
 title,
 emp_no,
 first_name,
 last_name,
 from_date,
 salary
INTO retiring_info_challenge_no_dups
FROM
 (SELECT 
 title,
 emp_no,
 first_name,
 last_name,
 salary, 
 from_date,
 ROW_NUMBER() OVER (PARTITION BY (emp_no) ORDER BY to_date DESC) rn
 FROM retiring_info_challenge
 ) tmp WHERE rn = 1
ORDER BY emp_no;

-- List of Employees born between Jan 1, 1952 and Dec 31, 1955

SELECT * FROM retiring_info_challenge_no_dups;

-- Number of Retiring Employees by Title
SELECT
  title,
  COUNT(emp_no) as emp_cnt
INTO count_by_title
from retiring_info_challenge_no_dups
group by 1

SELECT * FROM count_by_title;

-- Number of Titles Retiring
SELECT 
	COUNT(title)
INTO num_titles_retiring
FROM count_by_title;

SELECT * FROM num_titles_retiring;

-- Deliverabe 2: Mentorship Eligibility

SELECT  
    t.title,
	e.first_name, 
	e.last_name,
	t.from_date,
	t.to_date,
	e.emp_no,
	e.birth_date
INTO mentorship_data
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')

-- Partition the data to show only most recent title per employee
SELECT 
 emp_no,
 title,
 first_name,
 last_name,
 from_date,
 to_date
INTO mentorship_eligibility
FROM
 (SELECT 
 emp_no,
 title,
 first_name,
 last_name,
 from_date,
 to_date,
 ROW_NUMBER() OVER (PARTITION BY (emp_no) ORDER BY to_date DESC) rn
 FROM mentorship_data
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM mentorship_eligibility;

SELECT
  title,
  COUNT(emp_no) as emp_cnt
INTO mentorship_eligibility_by_title
FROM mentorship_eligibility
group by 1;

SELECT * FROM count_by_title;
SELECT * FROM mentorship_eligibility_by_title;
