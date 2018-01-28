-- ***********************
-- Name: Matteo Buonastella
-- ID: #########
-- Date: May 23 2017
-- Purpose: Lab 3 DBS301
-- ***********************

--1.    Write a query to display the tomorrow’s date in the following format:
-- September 28th of year 2016
--Your result will depend on the day when you RUN/EXECUTE this query.  Label the column Tomorrow.

-- Q1 SOLUTION --

SELECT (SYSDATE + 1) AS Tomorrow
FROM DUAL;


--2.    For each employee in departments 20, 50 and 60 display last name, first name, salary, and salary 
--increased by 5% and expressed as a whole number.  Label the column Good Salary.  Also add a column 
--that subtracts the old salary from the new salary and multiplies by 12. Label the column "Annual Pay Increase".


-- Q2 SOLUTION --

SELECT LAST_NAME AS "LAST NAME", FIRST_NAME AS "FIRST NAME", SALARY, (SALARY + (SALARY * 0.05)) AS "GOOD SALARY", ((SALARY + (SALARY * 0.05) - SALARY) * 12) AS "ANNUAL PAY INCREASE"
FROM EMPLOYEES
WHERE DEPARTMENT_ID  IN (20, 50 , 60);


--3.    Write a query that displays the employee’s Full Name and Job Title in the following format:
--          DAVIES, CURTIS is ST_CLERK 
--Only employees whose last name ends with S and first name starts with C or K.  Give this column an appropriate label like Person and Job.  Sort the result by the employees’ last names.

-- Q3 SOLUTION --
 
SELECT (UPPER(LAST_NAME)) ||', '|| (UPPER(FIRST_NAME)) || ' is ' || JOB_ID AS "PERSON AND JOB"
FROM EMPLOYEES
WHERE(UPPER(LAST_NAME) LIKE '%S') AND (UPPER(FIRST_NAME) LIKE 'C%' OR (UPPER(FIRST_NAME) LIKE 'K%'))
ORDER BY LAST_NAME;

--4.For each employee hired before 1992, display the employee’s last name, hire date and calculate the number of
--YEARS between TODAY and the date the employee was hired.
--a.Label the column Years worked. 
--b.Order your results by the number of years employed.  Round the number of years employed up to the closest whole number.

-- Q4 SOLUTION --

SELECT LAST_NAME AS "LAST NAME", HIRE_DATE AS "HIRE DATE", ROUND((SYSDATE - HIRE_DATE)/365, 0)  AS "YEARS WORKED"
FROM EMPLOYEES
WHERE HIRE_DATE < TO_DATE('01/JAN/1992','dd/mon/yyyy')
ORDER BY "YEARS WORKED" DESC;


--5.	Create a query that displays the city names, country codes and state province names, but only for those
--cities that starts with S and has at least 8 characters in their name. If city does not have a province name
--assigned, then put Unknown Province.  Be cautious of case sensitivity!

-- Q5 SOLUTION --
SELECT CITY, COUNTRY_ID AS "COUNTRY CODE", NVL(STATE_PROVINCE, 'Unknown Province') AS "PROVINCE NAME"
FROM LOCATIONS 
WHERE (UPPER(CITY) LIKE 'S_______%');


--6.	Display each employee’s last name, hire date, and salary review date, which is the first Thursday after a year of service, but only for those hired after 1997.  
--a.	Label the column REVIEW DAY. 
--b.	Format the dates to appear in the format like:
 --   THURSDAY, August the Thirty-First of year 1998
--c.	Sort by review date

-- Q6 SOLUTION --

SELECT LAST_NAME, HIRE_DATE, SALARY, (NEXT_DAY(SYSDATE + 365,'THURSDAY')) AS "REVIEW DAY"
FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE ('01/JAN/1997', 'DD/MON/YYYY')
ORDER BY "REVIEW DAY";