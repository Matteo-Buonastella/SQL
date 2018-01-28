-- *******************************
-- Name: Thomas Nolte            *
-- ID: 110641156                 *   
-- Date: 23-06-2017              *
-- Purpose: Assignment 1 - DBS301*
-- *******************************

-- *******************************
-- Name:Matteo Buonastella       *
-- ID:  102911161                *   
-- Date: 23-06-2017              *
-- Purpose: Assignment 1 - DBS301*
-- *******************************

--Question 1
--  	Display the employee number, full employee name, job and hire date of all employees hired
--    in May or November of any year, with the most recently hired employees displayed first. 
--    �	Also, exclude people hired in 1994 and 1995.  Full name should be in the form Lastname,
--    Firstname  with an alias called Full Name.
--    �	Hire date should point to the last day in May or November of that year (NOT to the exact day)
--    and be in the form of [May 31<st,nd,rd,th> of 1996] with the heading Start Date. Do NOT use LIKE operator. 
--    �	<st,nd,rd,th> means days that end in a 1, should have �st�, days that end in a 2 should have
--    �nd�, days that end in a 3 should have �rd� and all others should have �th�
--    �	You should display ONE row per output line by limiting the width of the Full Name to 25
--    characters. The output lines should look like this line:

--Question 1 solution

SELECT EMPLOYEE_ID AS "Employee Number", LAST_NAME ||', '|| FIRST_NAME AS "Full Name", JOB_ID, '[' || TO_CHAR(LAST_DAY(HIRE_DATE), 'Month ddth "of" YYYY') || ']' AS "Hire Date"
FROM EMPLOYEES
WHERE (HIRE_DATE NOT BETWEEN TO_DATE('01/01/1994','DD/MM/YYYY') AND TO_DATE('31/12/1995','DD/MM/YYYY')) AND
(EXTRACT (month from HIRE_DATE) = 5 OR EXTRACT (month from HIRE_DATE) = 11)
ORDER BY HIRE_DATE DESC;


-------------------------------------------------------------------------------------------------------------------

--Question 2
--  	List the employee number, full name, job and the modified salary for all employees
--    whose monthly earning (without this increase) is outside the range $6,000 � $11,000
--    and who are employed as Vice Presidents or Managers (President is not counted here).  
--    �	You should use Wild Card characters for this. 
--    �	VP�s will get 30% and managers 20% salary increase.  
--    �	Sort the output by the top salaries (before this increase) firstly.
--    �	Heading will be like Employees with increased Pay
--    �	The output lines should look like this sample line:


--Question 2 solution 

select 'Emp# ' || employees.employee_id || ' named ' || employees.last_name || ' ' || employees.first_name || ' who is ' || employees.job_id || ' will have a new salary of $' ||
    case 
        when employees.job_id like '%VP%' then (employees.salary*1.30)
        else (employees.salary*1.20)
    end as "Employees with increased Pay"
from 
      (select employees.employee_id from employees                                      
       where (employees.employee_id in (select employees.manager_id from employees)    
              and employees.manager_id is not null)                                     
       and employees.salary not between 6000 and 11000                                  
       order by employees.salary) emp                                                   
join employees on employees.employee_id=emp.employee_id
order by salary desc;

----------------------------------------------------------------------------------------------------------------------

--Question 3
--  	Display the employee last name, salary, job title and manager# of all employees not
--    earning a commission OR if they work in the SALES department, but only  if their
--    total monthly salary with $1000 included bonus and  commission (if  earned) is  greater
--    than  $15,000.  
--    �	Let�s assume that all employees receive this bonus.
--    �	If an employee does not have a manager, then display the word NONE 
--    �	instead. This column should have an alias Manager#.
--    �	Display the Total annual salary as well in the form of $135,600.00 with the 
--    �	heading Total Income. Sort the result so that best paid employees are shown first.
--    �	The output lines should look like this sample line:

--Question 3 solution
SELECT LAST_NAME AS "Last Name", to_char(SALARY,'$999,000.00') AS "Salary", JOB_ID AS "Job Title",  COALESCE(TO_CHAR(MANAGER_ID), 'NONE') AS "Manager#", TO_CHAR(SALARY*12+(1000*12),'$999,000.00') AS "Total Income"
FROM EMPLOYEES
WHERE SALARY + COALESCE(SALARY*COMMISSION_PCT,0) +1000 > 15000  AND (COMMISSION_PCT IS NULL OR JOB_ID LIKE ('SA%'))
ORDER BY "Total Income" DESC;

---------------------------------------------------------------------------------------------------------------------

--Question 4
--  	Display Department_id, Job_id and the Lowest salary for this combination under the alias
--    Lowest Dept/Job Pay, but only if that Lowest Pay falls in the range $6000 - $18000. Exclude
--    people who work as some kind of Representative job from this query and departments IT and SALES as well.
--    �	Sort the output according to the Department_id and then by Job_id.
--    �	You MUST NOT use the Subquery method.

--Question 4 solution

select employees.department_id || ' ' || employees.job_id as "Lowest Dept/Job Pay",to_char( min(employees.salary), '$999,999.99') as "Lowest Salary"
from employees
where employees.salary between 6000 and 18000
and upper(employees.job_id) not like '%REP%'                                         
and employees.department_id != 60
and employees.department_id != 80
group by employees.department_id, employees.job_id
order by  employees.department_id, employees.job_id;

---------------------------------------------------------------------------------------------------------------------

--Question 5
--  	Display last_name, salary and job for all employees who earn more than all lowest paid
--    employees per department outside the US locations.
--    �	Exclude President and Vice Presidents from this query.
--    �	Sort the output by job title ascending.
--    �	You need to use a Subquery and Joining with the NEW (Oracle9i) method.

--Question 5 solution

SELECT LAST_NAME as "Last Name", to_char(SALARY,'$999,000.00') as "Salary", JOB_ID as "Job Id"
FROM EMPLOYEES 
WHERE JOB_ID NOT LIKE '___VP' AND JOB_ID NOT LIKE '___PRES' AND 
SALARY > ANY (SELECT MIN(SALARY)
              FROM EMPLOYEES  JOIN (DEPARTMENTS)
              USING (DEPARTMENT_ID)
              JOIN LOCATIONS
              USING(LOCATION_ID)
              WHERE COUNTRY_ID NOT LIKE 'US')
ORDER BY JOB_ID;            


---------------------------------------------------------------------------------------------------------------------

--Question 6
--6.	Who are the employees (show last_name, salary and job) who work either in IT or MARKETING
--    department and earn more than the worst paid person in the ACCOUNTING department. 
--    �	Sort the output by the last name alphabetically.
--    �	You need to use ONLY the Subquery method (NO joins allowed).

--Question 6 solution

select employees.last_name as "Last Name", to_char(employees.salary, '$999,999.99') as "Salary", employees.job_id as "Job Title"
from  (select min(employees.salary) as salary
      from employees
      where employees.department_id = 110) lowpaid, employees
where (employees.department_id = 20 or employees.department_id = 60)
and employees.salary > lowpaid.salary
order by "Last Name";

---------------------------------------------------------------------------------------------------------------------

--Question 7
--  	Display alphabetically the full name, job, salary (formatted as a currency amount incl.
--    thousand separator, but no decimals) and department number for each employee who earns
--    less than the best paid unionized employee (i.e. not the president nor any manager nor any VP),
--    and who work in either SALES or MARKETING department.  
--    �	Full name should be displayed as Firstname  Lastname and should have the heading Employee.
--      Salary should be left-padded with the = symbol till the width of 12 characters. It should have an alias Salary.
--    �	You should display ONE row per output line by limiting the width of the 	Employee to 25 characters.
--    �	The output lines should look like this sample line:

--Question 7 solution

select  employees.first_name || ' ' || employees.last_name as "Employee", employees.job_id as "Job Title", to_char(employees.salary, '$999,999') as "Salary", employees.department_id as "Dpt#"
from employees

where employees.employee_id not in 
                            (select employees.manager_id from employees                    
                             where employees.manager_id is not null)
                             
and employees.salary < (select  max(employees.salary)                                        
                        from employees
                        where employees.employee_id not in 
                                                    (select employees.manager_id from employees 
                                                     where employees.manager_id is not null))
                                                     
and (employees.department_id = 80 or employees.department_id = 20)                           
order by "Employee";

---------------------------------------------------------------------------------------------------------------------

--Question 8
--    Display department name, city and number of different jobs in each department.
--    If city is null, you should print Not Assigned Yet.
--    �	This column should have alias City.
--    �	Column that shows # of different jobs in a department should have the heading # of Jobs
--    �	You should display ONE row per output line by limiting the width of the City to 25 characters.
--    �	You need to show complete situation from the EMPLOYEE point of view, meaning include also
--      employees who work for NO department (but do NOT display empty departments) and from
--      the CITY point of view meaning you need to display all cities without departments as well.
--    �	You need to use Outer Joining with the NEW (Oracle9i) method.


--Question 8 solution

select distinct dpt.department_name AS "Department Name",

case 
when dpt.location_id is null then 'Not Assigned Yet'                                                   
else to_char(locations.city)
end as "City",

case
when dpt.department_name is not null then count(dpt.department_name)                                   
when dpt.department_name is null then 1
end as "# of Jobs"

from (select distinct employees.job_id, departments.department_name, departments.location_id           
      from employees
      left outer join departments on departments.department_id = employees.department_id) dpt
      
right outer join locations on locations.location_id=dpt.location_id                                    

group by dpt.department_name, case 
when dpt.location_id is null then 'Not Assigned Yet'
else to_char(locations.city)
end;
