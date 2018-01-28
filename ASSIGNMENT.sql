--1.	Display the employee number, full employee name, job and hire date of all employees hired in May or November
--of any year, with the most recently hired employees displayed first. 
--	Also, exclude people hired in 1994 and 1995.  Full name should be in the form Lastname,  Firstname  with an alias called Full Name.
--Hire date should point to the last day in May or November of that year (NOT to the exact day) and be in the 
--form of [May 31<st,nd,rd,th> of 1996] with the heading Start Date. Do NOT use LIKE operator. 
--<st,nd,rd,th> means days that end in a 1, should have “st”, days that end in a 2 should have “nd”, days 
--that end in a 3 should have “rd” and all others should have “th”
--You should display ONE row per output line by limiting the width of the Full Name to 25 characters. The output lines should look like this line:
--174	Abel, Ellen	SA_REP	[May 31st of 1996]


SELECT EMPLOYEE_ID AS "Employee Number", LAST_NAME ||', '|| FIRST_NAME AS "Full Name", JOB_ID, '[' || TO_CHAR(LAST_DAY(HIRE_DATE), 'Month ddth "of" YYYY') || ']' AS "Hire Date"
FROM EMPLOYEES
WHERE (HIRE_DATE NOT BETWEEN TO_DATE('01/01/1994','DD/MM/YYYY') AND TO_DATE('31/12/1995','DD/MM/YYYY')) AND
(EXTRACT (month from HIRE_DATE) = 5 OR EXTRACT (month from HIRE_DATE) = 11)
ORDER BY HIRE_DATE DESC;


--2.List the employee number, full name, job and the modified salary for all employees whose monthly earning 
--(without this increase) is outside the range $6,000 – $11,000 and who are employed as Vice Presidents or Managers (President is not counted here).  
--You should use Wild Card characters for this. 
---VP’s will get 30% and managers 20% salary increase.  
--Sort the output by the top salaries (before this increase) firstly.
--Heading will be like Employees with increased Pay
--The output lines should look like this sample line:
--Emp# 124 named Kevin Mourgos who is ST_MAN will have a new salary of $6960

--SOLUTION


SELECT 'Emp# ' || EMPLOYEE_ID  || ' named ' || FIRST_NAME || ' ' || LAST_NAME || ' who is ' || JOB_ID || ' will have a new salary of $' ||
CASE JOB_ID 
WHEN 'ST_MAN' THEN (SALARY + (SALARY*0.2))
WHEN 'SA_MAN' THEN (SALARY + (SALARY*0.2))
WHEN 'MK_MAN' THEN (SALARY + (SALARY*0.2))
WHEN 'AD_VP' THEN  (SALARY + (SALARY*0.3))
END AS "Employee with increased pay"
FROM EMPLOYEES
WHERE JOB_ID LIKE '___MAN%' OR (JOB_ID LIKE '___VP%') AND (SALARY < 6000 OR SALARY > 11000)
ORDER BY SALARY DESC;


--3.Display the employee last name, salary, job title and manager# of all employees notearning a commission OR if they 
--work in the SALES department, but only  if their total monthly salary with $1000 included bonus and  commission (if  earned) is  greater  than  $15,000.  
--Let’s assume that all employees receive this bonus.
--If an employee does not have a manager, then display the word NONE 
--instead. This column should have an alias Manager#.
--Display the Total annual salary as well in the form of $135,600.00 with the 
--heading Total Income. Sort the result so that best paid employees are shown first.
--The output lines should look like this sample line:
--De Haan	17000	AD_VP	100	$216,000.00

SELECT LAST_NAME AS "Last Name", SALARY AS "Salary", JOB_ID AS "Job Title",  COALESCE(TO_CHAR(MANAGER_ID), 'NONE') AS "Manager#", TO_CHAR(SALARY*12+(1000*12),'$999,000.00') AS "Total Income"
FROM EMPLOYEES
WHERE SALARY + COALESCE(SALARY*COMMISSION_PCT,0) +1000 > 15000  AND (COMMISSION_PCT IS NULL OR JOB_ID LIKE ('SA%'))
ORDER BY "Total Income" DESC;

--4.Display Department_id, Job_id and the Lowest salary for this combination under the alias Lowest Dept/Job Pay,
--but only if that Lowest Pay falls in the range $6000 - $18000. Exclude people who work as some kind of 
--Representative job from this query and departments IT and SALES as well.
--Sort the output according to the Department_id and then by Job_id.
--You MUST NOT use the Subquery method.

SELECT DEPARTMENT_ID || ' ' || JOB_ID || ' ' || MIN(SALARY) AS "Lowest Dept/Job Pay" 
FROM EMPLOYEES JOIN DEPARTMENTS
USING (DEPARTMENT_ID)
WHERE JOB_ID NOT LIKE '%___REP%' AND JOB_ID NOT LIKE 'IT%' AND JOB_ID NOT LIKE 'SA%' 
GROUP BY DEPARTMENT_ID, JOB_ID
HAVING (MIN(SALARY) > 6000 AND MIN(SALARY) < 18000)
ORDER BY DEPARTMENT_ID, JOB_ID;

--5.Display last_name, salary and job for all employees who earn more than all lowest paid employees per department outside the US locations.
--Exclude President and Vice Presidents from this query.
--Sort the output by job title ascending.
--You need to use a Subquery and Joining with the NEW (Oracle9i) method.

SELECT LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEES 
WHERE JOB_ID NOT LIKE '___VP' AND JOB_ID NOT LIKE '___PRES' AND 
SALARY > ANY (SELECT MIN(SALARY)
              FROM EMPLOYEES  JOIN (DEPARTMENTS)
              USING (DEPARTMENT_ID)
              JOIN LOCATIONS
              USING(LOCATION_ID)
              WHERE COUNTRY_ID NOT LIKE 'US')
ORDER BY JOB_ID;            


--6.Who are the employees (show last_name, salary and job) who work either in IT or MARKETING 
--department and earn more than the worst paid person in the ACCOUNTING department. 
--Sort the output by the last name alphabetically.
--You need to use ONLY the Subquery method (NO joins allowed).


SELECT LAST_NAME, SALARY, JOB_ID 
FROM EMPLOYEES (SELECT 


