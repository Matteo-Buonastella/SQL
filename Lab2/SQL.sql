-- ***********************
-- Name: Matteo Buonastella
-- ID: 102911161
-- Date: The current date
-- Purpose: Lab 2 DBS301
-- ***********************

-- 1.	Display the employee_id, last name and salary of employees earning in
--the range of $8,000 to $15,000.  Sort the output by top salaries first and 
--then by last name.

--SOLUTION
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE salary >= 8000 AND salary <= 15000
ORDER BY salary DESC, last_name; 

-- 2.	Modify previous query (#1) so that additional condition is to display 
--only if they work as Programmers or Sales Representatives. Use same sorting as before.

--SOLUTION
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, JOB_ID AS "JOB TITLE"
FROM EMPLOYEES
WHERE (SALARY >= 8000 AND SALARY <= 15000) AND (JOB_ID = 'IT_PROG' OR JOB_ID  = 'SA_REP')
ORDER BY SALARY DESC, LAST_NAME; 

-- 3.	The Human Resources department wants to find high salary and low salary employees. 
--Modify previous query (#2) so that it displays the same job titles but for people who
--earn outside the given salary range from question 1. Use same sorting as before.

--SOLUTION
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, JOB_ID AS "JOB TITLE"
FROM EMPLOYEES
WHERE (SALARY < 8000 OR SALARY > 15000) AND (JOB_ID = 'IT_PROG' OR JOB_ID  = 'SA_REP')
ORDER BY SALARY DESC, LAST_NAME;

--4. The company needs a list of long term employees, in order to give them 
--a thank you dinner. Display the last name, job_id and salary of employees hired
--before 1998. List the most recently hired employees first.

--SOLUTION
SELECT LAST_NAME, JOB_ID, SALARY, HIRE_DATE
FROM EMPLOYEES
WHERE TRUNC(HIRE_DATE) <= TO_DATE('31/DEC/1998','dd/mon/yyyy')
ORDER BY HIRE_DATE DESC;

--5. 5.	Modify previous query (#4) so that it displays only employees earning 
--more than $10,000. List the output by job title alphabetically and then by highest paid employees.

--SOLUTION
SELECT LAST_NAME, JOB_ID AS "JOB TITLE", SALARY, HIRE_DATE
FROM EMPLOYEES
WHERE TRUNC(HIRE_DATE) <= TO_DATE('31/DEC/1998','dd/mon/yyyy')
AND (SALARY > 10000)
ORDER BY JOB_ID, SALARY DESC;

--6.	Display the job titles and full names of employees whose first name contains an ‘e’ or ‘E’ anywhere. The output should look like:
--Job Title	Full name
--------------------------------------
--	Neena 	Kochhar
--    … more rows

--SOLUTION
SELECT  JOB_ID AS "JOB TITLE", concat(concat (FIRST_NAME, ' '), LAST_NAME) AS "FULL NAME" 
FROM EMPLOYEES
WHERE FIRST_NAME LIKE '%E%' OR FIRST_NAME LIKE '%e%';

--7.Create a report to display last name, salary, and commission percent for all 
--employees that earn a commission.

--SOLUTION

SELECT LAST_NAME AS "LAST NAME", SALARY, COMMISSION_PCT AS "COMMISSION %"
FROM EMPLOYEES
WHERE COMMISSION_PCT > 0;


--8.Do the same as question 7, but put the report in order of descending salaries.

--SOLUTION

SELECT LAST_NAME AS "LAST NAME", SALARY, COMMISSION_PCT AS "COMMISSION %"
FROM EMPLOYEES 
WHERE COMMISSION_PCT > 0
ORDER BY SALARY DESC;

--9.Do the same as 8, but use a numeric value instead of a column name to do the sorting.

--SOLUTION

SELECT LAST_NAME AS "LAST NAME", SALARY, COMMISSION_PCT AS "COMMISSION %"
FROM EMPLOYEES 
WHERE COMMISSION_PCT > 0
ORDER BY CAST(SALARY AS int) DESC;
