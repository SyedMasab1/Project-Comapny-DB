-- DESIGN DATABASE ---
CREATE DATABASE Company;

-- SPECIFY THE DATABASE ---
use company;

--- CREATE TABLE ---

create table Employees(
Name Varchar(80),
Employee_ID INT primary key auto_increment,
Age INT check (Age >18),
Shift varchar(100)
);

Create table Employees_Info(
Employee_ID INT primary key auto_increment,
Salary INT default '25000',
Benefits varchar(89),
Benefits_pay decimal (7,2),
Department varchar(80)
);

Create table Department(
Department_ID int primary key auto_increment,
Department_name varchar(130),
HOD_ID INT unique,
HOD_Name varchar(90),
Employee_ID INT unique
);

CREATE TABLE Finance (
    Finance_ID INT PRIMARY KEY AUTO_INCREMENT,
    Employee_ID INT UNIQUE,
    Bonus DECIMAL(10, 2),
    Deductions DECIMAL(10, 2),
    Payment_Date DATE
);

-- STRUCTURE OF TABLE---
DESC Employees;
desc Employees;

--- LISTED THE TABLE IN DATABASE --
SHOW TABLES;

-- INSERTING THE DATA INTO TABLE ---
INSERT INTO employees(Name,Age,Shift) values ('jhon',34,'9 to 5');

insert into employees_info(department_ID) 
VALUES (2);


insert into	employees_info(salary,Benefits,Benefits_pay,Department) values
 (150000,'Medical+Fuel+Home Allowance',65000.00,"HR");

INSERT INTO Employees(Name,Age,shift) values ('Sam',47,"9 to 5");

insert INTO department(department_name,HOD_ID,HOD_Name,Employee_ID) VALUES
 ('Administration',141,'Mr.Saibtan',101);
 
 INSERT INTO Finance (Employee_ID, Bonus, Deductions, Payment_Date)
VALUES 
    (101, 550.00, 110.00, '2024-09-15'),
    (102, 1050.00, 210.00, '2024-09-15'),
    (103, 700.00, 140.00, '2024-09-15'),
    (104, 650.00, 130.00, '2024-09-15'),
    (105, 950.00, 190.00, '2024-09-15');
    INSERT INTO Finance (Employee_ID, Bonus, Deductions, Payment_Date)
VALUES 
    (1007, 800.00, 160.00, '2024-09-20'),
    (1005, 1200.00, 240.00, '2024-09-20'),
    (1004, 950.00, 190.00, '2024-09-20'),
    (1009, 1000.00, 200.00, '2024-09-20'),
    (1010, 850.00, 170.00, '2024-09-20');

--- RETRIEVE THE DATA FROM TABLES ----
SELECT * FROM employees;
select * FROM departmenT;
select * FROM employees_info;
SELECT * FROM Finance;

-- REMOVE THENULL VALUES ---
DELETE FROM employees_info
WHERE (Employee_ID IS NULL OR Salary
 IS NULL OR Benefits
 IS NULL OR Benefits_pay 
 IS NULL OR Department)
 AND Employee_ID between 111 AND 130;

-- MODIFY THE TABLES ---
ALTER TABLE employees_info 
drop column Department_ID;

alter TABLE employees_info ADD column
Department_ID int unique;
















ALTER TABLE employees_info drop column
Department_id;

UPDATE employees_info SET department_ID=2
WHERE department_ID=NULL;

update employees SET department_id =11
WHERE employee_ID=1010;

update department SET HOD_Name='Junaid'
WHERE HOD_Name ='';

UPDATE employees_info set department_ID=10 WHERE Employee_ID=109;
UPDATE employees_info SET Department_ID = 11 WHERE employee_ID = 110;

alter TABLE Department
modify Department_Name varchar (80);

ALTER TABLE Employees MODIFY shift VARCHAR(100);

ALTER TABLE employees ADD column
Department_ID INT unique;


-- REMOVE THE RECORDS ---
delete from employees WHERE Shift=4 AND
Age = 29;

DELETE FROM employees_info WHERE Department_ID=2;
DELETE FROM department where HOD_ID=121;

-- DROP THE TABLE ---
DROP table employees;

--- RELATION BETWEEN TABLES ---

-- One to Many Relation ----
ALTER table employees ADD constraint
FK_Employees_Department
foreign key (employee_ID) references department(Department_ID);

-- ONE TO ONE RELATION --
ALTER TABLE employees_info ADD constraint
FK_Employees_salary
foreign key (employee_ID) references finance(Finance_ID);

---  ONE TO ONE RELATION --
ALTER table employees ADD constraint
FK_Employees_Info
foreign key (employee_ID) references employees_info(Employee_ID);
select * FROM department;

--- ONE TO MANY RELATION ----
alter TABLE finance ADD constraint
FK_Finance_Details 
foreign key (finance_ID) references department(HOD_ID);

--- DISABLE FOREIGN KEY FOR OPERATIONS ----
SET FOREIGN_KEY_CHECKS =0;

--- RE-ENABLE FOREIGN KEY ---
SET FOREIGN_KEY_CHECKS = 1;


-- Calculate the total salary paid to all employees in each department
select SUM(Salary) ,department
FROM employees_info
group by Department;

-- Question: Find the average age of employees working in the 'Finance' department.
SELECT avg(Age)  as Average_age
FROM employees
 inner JOIN department
ON employees.Department_ID=department.Department_ID
WHERE Department_Name= 'finance';
select * from employees;
select * from department;
---- Question: Count the number of employees in each department.
SELECT department.department_Name,department.Department_ID,
count(employees.Employee_ID) AS NO_of_Employees
FROM department
JOIN employees
on department.Department_ID= employees.Department_ID
group by department.Department_ID,department.Department_Name;

--- Create a view to show the employees
select * FROM employees;
select * FROM employees_info;
select * FROM finance;
select * FROM department;

-- Create a view to show the employees' complete details, including their department name and salary.
CREATE VIEW Employees_Information AS
SELECT employees.Employee_ID,employees.Name,department.Department_ID,department.Department_Name,
employees_info.Salary
FROM employees 
JOIN
department on employees.Department_ID=department.Department_ID
LEFT JOIN finance ON employees.Employee_ID=finance.Employee_ID
LEFT JOIN employees_info ON employees.Employee_ID=employees_info.Employee_ID;

select * FROM Employees_Information ;

--- Create a CTE to calculate the total deductions and bonuses for each employee and find the net payment

WITH Payments_of_Employees_CTE AS(
SELECT Employee_ID,sum(Bonus) - sum(deductions) AS Net_Payment
FROM finance
GROUP BY Employee_ID)
SELECT employee_ID, Net_Payment
FROM Payments_of_Employees_CTE;

--- Question: List all employees along with their department name and HOD details
SELECT department.Department_Name,department.HOD_ID,department.HOD_Name,
employees.Employee_ID FROM department
LEFT join
employees ON department.Department_ID=employees.Department_ID;

--- Question: Find employees who earn more than the average salary of their department.
SELECT employees_info.Employee_ID,employees_info.Department_ID,employees_info.Department
FROM employees_info
WHERE Salary >
(SELECT AVG(employees_info.Salary)
FROM employees_info);

--- List departments with more than 5 employees and order them by employee count in descending order
select * FROM employees_info;
SELECT COUNT(employees_info.Employee_ID),employees_info.Department
FROM employees_info
group by Department
having COUNT(employees_info.Employee_ID) < 5
order by COUNT(employees_info.Employee_ID);

--- Question: Show a list of all employees who are either in the Finance department or have a bonus assigned.
SELECT * FROM finance;

 select bonus,Payment_Date,Employee_ID FROM finance
WHERE Bonus > 0 
UNION
SELECT employees_info.Employee_ID,employees_info.Department,employees_info.Employee_ID
from employees_info WHERE Department ='Finance';

--- Question: Create an index on the Employee_ID column in the employees_info table for faster lookups.
CREATE INDEX Employees_Identification
ON employees_info(employee_ID);


--- Question: Create a trigger to update the total salary of an employee in the employees_info table whenever a new record is inserted into the Finance table.
DELIMITER //

CREATE TRIGGER Finance_Updates
AFTER INSERT ON finance
for each row
begin
update employees_info
SET Salary = Salary + new.salary - new.Deduction
WHERE employee_id = new.employee_ID;

END //
DELIMITER ;



 --- Question: Find all employees whose names start with the letter 'A'
SELECT * FROM employees
WHERE name LIKE 'A%'; 


