CREATE TABLE MY_EMPLOYEE(
Id NUMBER(4) NOT NULL,
Last_Name VARCHAR2(25),
First_Name VARCHAR2(25),
User_Id VARCHAR2(8),
Salary NUMBER(9,2)
);

--1
INSERT INTO MY_EMPLOYEE
SELECT 126,'Popov', 'Olga', 'opopov', 8500 FROM DUAL UNION ALL
SELECT 127, 'Chen', 'Ling', 'lcheng', 14500 FROM DUAL UNION ALL 
SELECT 128, 'Dunn', 'David', 'ddunn', NULL FROM DUAL;

INSERT INTO MY_EMPLOYEE (Id, Last_Name, First_Name, User_Id, Salary)
        SELECT 108, 'Preston', 'Scott', 'spreston', NULL 
        FROM DUAL UNION ALL
        SELECT 109, 'Gomez', 'Rita', 'rgomez', NULL
        FROM DUAL;
SAVEPOINT FIRST;
SELECT * FROM MY_EMPLOYEE;

--2
INSERT INTO MY_EMPLOYEE (Id, Last_Name, First_Name, User_Id, Salary)
(SELECT EMPLOYEE_ID, Last_Name, First_Name, NVL(JOB_ID, 'generic'), Salary
        FROM EMPLOYEES 
        WHERE JOB_ID LIKE '%PROG');
SELECT * FROM MY_EMPLOYEE;

--3
UPDATE MY_EMPLOYEE
SET Last_Name = 'Jones',
    Salary = 9000
WHERE Last_Name = 'Gomez';

UPDATE MY_EMPLOYEE
SET Salary = Salary + 2000
WHERE Salary < 10500;
COMMIT;
SELECT * FROM MY_EMPLOYEE;     
--4
INSERT INTO MY_EMPLOYEE 
VALUES (128, 'Bob', 'Thomas', NULL, 13500);

DELETE FROM MY_EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEES
                WHERE LAST_NAME LIKE ('Higgins'));
SAVEPOINT ONE;
SELECT * FROM MY_EMPLOYEE;

UPDATE MY_EMPLOYEE
SET Salary = Salary - 1000
WHERE SALARY > (SELECT SALARY
                FROM MY_EMPLOYEE
                WHERE LAST_NAME LIKE 'Popov');
SAVEPOINT TWO;
SELECT * FROM MY_EMPLOYEE;

DELETE FROM MY_EMPLOYEE
WHERE ID > 120;
SELECT * FROM MY_EMPLOYEE;
ROLLBACK TO TWO;
SAVEPOINT THREE;
SELECT * FROM MY_EMPLOYEE;



