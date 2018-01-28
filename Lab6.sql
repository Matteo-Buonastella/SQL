-- ***********************
-- Name: Matteo Buonastella
-- ID: #########
-- Date: June 14 2017
-- Purpose: Lab 6 DBS301
-- ***********************

-- 1
AUTOCOMMIT ON

-- 2 
INSERT INTO EMPLOYEES (FIRST_NAME, LAST_NAME, SALARY, COMMISSION_PCT, DEPARTMENT_ID, MANAGER_ID, HIRE_DATE, EMPLOYEE_ID, EMAIL, JOB_ID)
VALUES ('Matteo', 'Buonastella', null, 0.2, 90,100, SYSDATE, 999, 'WORK', 'IT_PROG')

-- 3
UPDATE EMPLOYEES
SET SALARY = 2500
WHERE LAST_NAME = 'Matos' OR LAST_NAME = 'Whalen';

--4.Display the last names of all employees who are in the same department as the employee named Abel.
--SOLUTION

SELECT LAST_NAME AS "Last Name"
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES
                        WHERE LAST_NAME = 'Abel');
                        
--5.	Display the last name of the lowest paid employee(s)
--SOLUTION

SELECT LAST_NAME AS "Last Name"
FROM EMPLOYEES
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEES);

-- 6.Display the city that the lowest paid employee(s) are located in.
--SOLUTION

SELECT CITY AS City
FROM LOCATIONS JOIN DEPARTMENTS
USING (LOCATION_ID)
JOIN EMPLOYEES
USING(DEPARTMENT_ID)
WHERE SALARY = (SELECT MIN(SALARY)
                 FROM EMPLOYEES);


--7.Display the last name, department_id, and salary of the lowest paid employee(s)
--in each department.  Sort by Department_ID. (HINT: careful with department 60)
--SOLUTION

SELECT LAST_NAME AS "Last Name", DEPARTMENT_ID AS "Department Id", SALARY AS Salary
FROM EMPLOYEES JOIN DEPARTMENTS
USING(DEPARTMENT_ID)
WHERE SALARY IN (SELECT  MIN(SALARY)
                FROM EMPLOYEES
                GROUP BY DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID;
                
                
--8.Display the last name of the lowest paid employee(s) in each city

SELECT LAST_NAME AS "Last Name", CITY AS City, SALARY
FROM EMPLOYEES JOIN DEPARTMENTS
USING (DEPARTMENT_ID)
JOIN LOCATIONS 
USING(LOCATION_ID)
WHERE SALARY IN (SELECT MIN(SALARY)
                FROM EMPLOYEES
                JOIN DEPARTMENTS
                USING (DEPARTMENT_ID)
                JOIN LOCATIONS 
                USING(LOCATION_ID)
                GROUP BY CITY);

--9.Display last name and salary for all employees who earn less than the lowest salary in 
--ANY department.  Sort the output by top salaries first and then by last name.

--SOLUTION

SELECT LAST_NAME AS "Last Name", SALARY AS "Salary"
FROM EMPLOYEES JOIN DEPARTMENTS
USING(DEPARTMENT_ID)
WHERE SALARY < ANY (SELECT MIN(SALARY)
                FROM EMPLOYEES JOIN DEPARTMENTS
                USING(DEPARTMENT_ID)
                GROUP BY DEPARTMENT_ID)
ORDER BY SALARY DESC, LAST_NAME;

--10.Display last name, job title and salary for all employees whose salary matches
--any of the salaries from the IT Department. Do NOT use Join method.
--Sort the output by salary ascending first and then by last_name

SELECT LAST_NAME AS "Last Name", DEPARTMENT_NAME AS "Job Id", SALARY AS "Salary"
FROM EMPLOYEES e, DEPARTMENTS d
WHERE SALARY = ANY(SELECT SALARY
                FROM EMPLOYEES,DEPARTMENTS
                WHERE JOB_ID = 'IT_PROG')
AND e.DEPARTMENT_ID = d.DEPARTMENT_ID



