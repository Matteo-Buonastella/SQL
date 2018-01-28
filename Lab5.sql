--1.    Display the department name, city, street address and postal code for 
--departments sorted by city and department name.

--SOLUTION

SELECT DEPARTMENT_NAME AS "Department Name", CITY AS City, STREET_ADDRESS AS "Street Address", POSTAL_CODE AS "Postal Code"
FROM DEPARTMENTS
NATURAL JOIN LOCATIONS
ORDER BY  CITY, DEPARTMENT_NAME;

--2.    Display full name of employees as a single field using format of Last,
--First, their hire date, salary, department name and city, but only for departments 
--with names starting with an A or S sorted by department name and employee name. 

--SOLUTION

SELECT LAST_NAME ||', '|| FIRST_NAME ||', '|| HIRE_DATE ||', $'|| SALARY ||', '|| DEPARTMENT_NAME ||', '|| CITY AS Information
FROM EMPLOYEES 
JOIN DEPARTMENTS 
USING (DEPARTMENT_ID)
JOIN LOCATIONS
USING (LOCATION_ID)
WHERE FIRST_NAME LIKE 'A%' OR FIRST_NAME LIKE'S%'
ORDER BY DEPARTMENT_NAME, LAST_NAME;

--3.Display the full name of the manager of each department in states/provinces
--of Ontario, California and Washington along with the department name, city,
--postal code and province name.   Sort the output by city and then by department name.

--SOLUTION

SELECT FIRST_NAME ||' ' || LAST_NAME AS "Full Name", DEPARTMENT_NAME AS "Department Name", CITY AS "City", POSTAL_CODE AS "Postal Code", STATE_PROVINCE AS "Province Name"
FROM EMPLOYEES
JOIN DEPARTMENTS
USING(MANAGER_ID)
JOIN LOCATIONS
USING (LOCATION_ID)
WHERE STATE_PROVINCE IN ('Ontario', 'California', 'Washington');


--4.Display employee’s last name and employee number along with their manager’s
--last name and manager number. Label the columns Employee, Emp#, Manager, and Mgr# respectively.

--SOLUTION

SELECT EMP.LAST_NAME AS "Employee", EMP.EMPLOYEE_ID AS "Emp#", MGR.LAST_NAME AS "Manager", MGR.MANAGER_ID AS "Mgr#"
FROM EMPLOYEES EMP JOIN EMPLOYEES MGR
ON (EMP.EMPLOYEE_ID = MGR.MANAGER_ID);


--5.Display the department name, city, street address, postal code and country name for all
--Departments. Use the JOIN and USING form of syntax.  Sort the output by department name descending.

--SOLUTION
SELECT DEPARTMENT_NAME AS "Department Name", CITY AS City, STREET_ADDRESS AS "Street Address", POSTAL_CODE AS "Postal Code", COUNTRY_NAME AS "Country Name"
FROM DEPARTMENTS JOIN LOCATIONS
USING (LOCATION_ID)
JOIN COUNTRIES
USING(COUNTRY_ID)
ORDER BY DEPARTMENT_NAME DESC;


--6.Display full name of the employees, their hire date and salary together with their department name,
--but only for departments which names start with A or S. Full name should be in format of:
--a.	First / Last. Use the JOIN and ON form of syntax.
--b.	Sort the output by department name and then by last name.

--SOLUTION

SELECT FIRST_NAME || ' / '|| LAST_NAME AS "Full Name", HIRE_DATE AS "Hire Date", '$'||SALARY AS "Salary", DEPARTMENT_NAME AS "Department Name"
FROM EMPLOYEES e JOIN DEPARTMENTS d
ON (e.department_id = d.department_id)
WHERE DEPARTMENT_NAME LIKE 'A%' OR DEPARTMENT_NAME LIKE 'S%'
ORDER BY DEPARTMENT_NAME, LAST_NAME;


--7.Rewrite the previous question by using Standard (Old -- prior to Oracle9i) Join method.

--SOLUTION

SELECT FIRST_NAME || ' / '|| LAST_NAME AS "Full Name", HIRE_DATE AS "Hire Date", '$'||SALARY AS "Salary", B.DEPARTMENT_NAME AS "Department Name"
FROM EMPLOYEES A, DEPARTMENTS B
WHERE  (A.department_id = B.department_id) AND (DEPARTMENT_NAME LIKE 'A%' OR DEPARTMENT_NAME LIKE 'S%')
ORDER BY DEPARTMENT_NAME, LAST_NAME;


--8.Display full name of the manager of each department in provinces Ontario, California and
--Washington plus department name, city, postal code and province name. Full name should be in format as follows:
--a.Last, First.  Use the JOIN and ON form of syntax.
--b.Sort the output by city and then by department name. 

--SOLUTION

SELECT LAST_NAME || ', ' || FIRST_NAME AS "Full Name", DEPARTMENT_NAME AS "Department Name", CITY AS City,
POSTAL_CODE AS "Postal Code", STATE_PROVINCE AS Province
FROM EMPLOYEES a JOIN DEPARTMENTS b 
ON (a.EMPLOYEE_ID = b.MANAGER_ID)
JOIN LOCATIONS c 
ON (c.STATE_PROVINCE IN ('Ontario','California'))
ORDER BY CITY, DEPARTMENT_NAME;


--9.Rewrite the previous question by using Standard (Old -- prior to Oracle9i) Join method.

--SOLUTION

SELECT LAST_NAME || ', ' || FIRST_NAME AS "Full Name", DEPARTMENT_NAME AS "Department Name", CITY AS City,
POSTAL_CODE AS "Postal Code", STATE_PROVINCE AS Province
FROM EMPLOYEES A, DEPARTMENTS B, LOCATIONS C
WHERE a.EMPLOYEE_ID = b.MANAGER_ID AND c.STATE_PROVINCE IN ('Ontario','California')
ORDER BY CITY, DEPARTMENT_NAME;

--10.Display the department name and Highest, Lowest and Average pay per each department. Name these results High, Low and Avg.
--a.Use JOIN and ON form of the syntax.
--b.Sort the output so that department with highest average salary are shown first.

--SOLUTION

SELECT DEPARTMENT_NAME AS "Department Name", TO_CHAR(MAX(SALARY),'$99,999.99') AS "Highest", TO_CHAR(MIN(SALARY),'$99,999.99') AS "Lowest", TO_CHAR(SUM(SALARY)/COUNT(*),'$99,999.99') AS "Average"
FROM EMPLOYEES a JOIN DEPARTMENTS b
ON (a.DEPARTMENT_ID = b.DEPARTMENT_ID)
GROUP BY DEPARTMENT_NAME
ORDER BY TO_CHAR(MIN(SALARY),'$99,999.99') DESC;

--11.Display the employee last name and employee number along with their manager’s last name and manager number. Label the columns Employee, 
--a.Emp#, Manager, and Mgr#, respectively. Include also employees who do
--b.NOT have a manager and also employees who do NOT supervise anyone (or you could say managers without employees to supervise).

--SOLUTION
SELECT a.LAST_NAME AS "Employee", a.EMPLOYEE_ID AS "Employee #", b.LAST_NAME AS "Manager", b.MANAGER_ID AS "Manager #"
FROM EMPLOYEES a JOIN EMPLOYEES b
ON (a.EMPLOYEE_ID = b.MANAGER_ID) OR (A.EMPLOYEE_ID IS NOT NULL AND b.MANAGER_ID IS NULL) OR (A.EMPLOYEE_ID IS NULL AND b.MANAGER_ID IS NOT NULL);

