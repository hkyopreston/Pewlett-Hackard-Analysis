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
