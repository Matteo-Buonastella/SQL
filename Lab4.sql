-- ***********************
-- Name: Matteo Buonastella
-- ID: #########
-- Date: June 1 2017
-- Purpose: Lab 3 DBS301
-- ***********************

-- Question 1 .	Display the difference between the Average pay and Lowest pay
--in the company.  Name this result Real Amount.  Format the output as currency with 2 decimal places.

-- Q1 SOLUTION --

SELECT TO_CHAR(((SUM(SALARY)/COUNT(*)) - MIN(SALARY)),'$9,999.00') AS "Real Amount"
FROM EMPLOYEES;

-- Question 2.	Display the department number and Highest, Lowest and Average pay
--per each department. Name these results High, Low and Avg.  Sort the output so
--that the department with highest average salary is shown first.  Format the output as currency where appropriate.

-- Q2 SOLUTION --

SELECT DEPARTMENT_ID, TO_CHAR(MAX(SALARY),'$99,999.00') AS "Highest", TO_CHAR(MIN(SALARY),'$99,999.00') AS "Lowest", TO_CHAR(SUM(SALARY)/COUNT(*),'$99,999.00') AS "Average"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY "Average" DESC;

--Question 3.	Display how many people work the same job in the same department. Name these results
--Dept#, Job and How Many. Include only jobs that involve more than one person.  Sort
--the output so that jobs with the most people involved are shown first.

-- Q3 SOLUTION --

SELECT DEPARTMENT_ID AS "Dept#", JOB_ID AS "Job", COUNT(*) AS "How Many"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
HAVING COUNT(*) > 1
ORDER BY "How Many" DESC;


--Question 4.For each job title display the job title and total amount paid each
--month for this type of the job. Exclude titles AD_PRES and AD_VP and also include
--only jobs that require more than $12,000.  Sort the output so that top paid jobs are shown first.

-- Q4 SOLUTION --
SELECT JOB_ID AS "Job Title", (SUM(SALARY)) AS "Salary"
FROM EMPLOYEES
WHERE JOB_ID NOT IN ('AD_PRES','AD_VP')
GROUP BY  JOB_ID, SALARY
HAVING SALARY > 12000
ORDER BY SALARY DESC;


--Question 5.	For each manager number display how many persons 
--he / she supervises. Exclude managers with numbers 100, 101 and 102 and 
--also include only those managers that supervise more than 2 persons. 
--Sort the output so that manager numbers with the most supervised persons are shown first.

-- Q5 SOLUTION --
SELECT MANAGER_ID AS "Manager ID", COUNT(*) AS "Persons supervised"
FROM EMPLOYEES
WHERE MANAGER_ID NOT IN (100,101,102) 
GROUP BY MANAGER_ID
HAVING COUNT(*) > 2
ORDER BY "Persons supervised" DESC;

--Question 6.	For each department show the latest and earliest hire date, BUT
-- exclude departments 10 and 20 
-- exclude those departments where the last person was hired in this century. 
-- Sort the output so that the most recent, meaning latest hire dates, are shown first.

-- Q6 SOLUTION --
SELECT DEPARTMENT_ID AS "Department", MIN(HIRE_DATE) AS "Earliest Hire Date", MAX(HIRE_DATE) AS "Latest Hire Date"
FROM EMPLOYEES
WHERE DEPARTMENT_ID NOT IN (10,20)
GROUP BY DEPARTMENT_ID
HAVING MAX(HIRE_DATE) < TO_DATE('01/01/2000','dd/mm/yyyy')
ORDER BY "Latest Hire Date"DESC;
