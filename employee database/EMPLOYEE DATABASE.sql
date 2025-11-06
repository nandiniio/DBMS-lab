show databases;
create database employeee;
use employeee;

create table project(
Pno int(10), Ploc varchar(50), Pname varchar(50),
primary key (Pno)
);

create table incentives(
empno int(10), incentive_date date, incentive_amount int(10),
primary key(incentive_date),
foreign key(empno) references employee(empno)
);

create table employee(
empno int(10), ename varchar(50), MGR_no int(10), hiredate date, sal int (10), deptno int(10),
primary key(empno),
foreign key(deptno) references dept(deptno)
);

create table assigned_to(
empno int(10), Pno int(10), job_role varchar(50),
foreign key(empno) references employee(empno),
foreign key(Pno) references project(Pno)
);

create table dept(
deptno int(10), dname varchar(20), dloc varchar(50),
primary key(deptno)
);

insert into dept (deptno, dname, dloc) values
(10, 'Sales', 'Mumbai'),
(20, 'Development', 'Bangalore'),
(30, 'HR', 'Mysuru'),
(40, 'Operations', 'Hyderabad');


insert into project (Pno, Ploc, Pname) values
(1, 'Bangalore', 'A'),
(2, 'Hyderabad', 'B'),
(3, 'Mysuru', 'C'),
(4, 'Mumbai', 'D');

insert into employee (empno, ename, MGR_no, hiredate, sal, deptno) values
(100, 'Alice',  NULL, '2015-01-10', 220000, 20),
(200, 'Bob',    NULL, '2016-03-15', 200000, 30),
(300, 'Carol',  NULL, '2014-07-20', 180000, 10);

insert into employee (empno, ename, MGR_no, hiredate, sal, deptno) values
(110, 'Ramesh',   100,  '2018-02-01', 120000, 20),
(210, 'Sameer',    200,  '2019-06-10', 100000, 30),
(310, 'Madhur',  300,  '2017-11-25',  95000, 10); 

insert into employee (empno, ename, MGR_no, hiredate, sal, deptno) values
(111, 'Grace',  110, '2020-08-05',  50000, 20),
(112, 'Hritik',  110, '2021-01-12',  60000, 20),
(113, 'Leo',    100, '2019-12-01',  80000, 20),
(211, 'Ivan',   210, '2022-03-03',  50000, 30),
(301, 'Ken',    300, '2020-05-18',  60000, 10),
(311, 'Judy',   300, '2021-09-07',  40000, 10);

INSERT INTO incentives (empno, incentive_date, incentive_amount) VALUES
(111, '2024-02-15', 5000),
(211, '2024-03-10', 6000),
(301, '2024-01-20', 7000);

INSERT INTO assigned_to (empno, Pno, job_role) VALUES
(100, 1, 'Project Head'),
(110, 1, 'Manager'),
(111, 1, 'Developer'), 
(113, 4, 'Senior Dev'),
(200, 3, 'Project Head'),
(210, 3, 'Manager'),
(211, 2, 'HR Analyst'),    
(300, 4, 'Project Head'),   
(301, 4, 'Sales Rep'),     
(310, 2, 'Ops Manager'),   
(311, 4, 'Sales Exec');     

-- 1. Employees working on projects located in Bangalore, Hyderabad, or Mysuru
select a.empno
from assigned_to a
join project p on a.Pno = p.Pno
where p.Ploc in ('Bangalore', 'Hyderabad', 'Mysuru');

-- 2. Employees who didn’t receive incentives
SELECT e.empno, e.ename
FROM employee e
LEFT JOIN incentives i ON e.empno = i.empno
WHERE i.empno IS NULL;

-- 3. Employees whose project location = department location
SELECT 
    e.ename,  e.empno, d.dname AS department_name, a.job_role, d.dloc AS department_location, p.Ploc AS project_location
FROM employee e
JOIN dept d ON e.deptno = d.deptno
JOIN assigned_to a ON e.empno = a.empno
JOIN project p ON a.Pno = p.Pno
WHERE d.dloc = p.Ploc;

-- 4. Managers with the maximum number of employees
SELECT 
    m.ename AS manager_name,
    COUNT(e.empno) AS total_employees
FROM employee e
JOIN employee m ON e.MGR_no = m.empno
GROUP BY m.empno, m.ename
HAVING COUNT(e.empno) = (
    SELECT MAX(emp_count)
    FROM (
        SELECT COUNT(e1.empno) AS emp_count
        FROM employee e1
        JOIN employee m1 ON e1.MGR_no = m1.empno
        GROUP BY m1.empno
    ) AS counts
);

-- 5. Managers whose salary > average salary of their employees
SELECT 
    m.ename AS manager_name,
    m.sal AS manager_salary,
    AVG(e.sal) AS avg_employee_salary
FROM employee m
JOIN employee e ON e.MGR_no = m.empno
GROUP BY m.empno, m.ename, m.sal
HAVING m.sal > AVG(e.sal);

-- 6. Second top-level managers (those who report to top-level managers)
SELECT 
    e.ename AS second_top_level_manager,
    m.ename AS top_level_manager,
    d.dname AS department_name
FROM employee e
JOIN employee m ON e.MGR_no = m.empno
JOIN dept d ON e.deptno = d.deptno
WHERE m.MGR_no IS NULL;

-- 7. Find the employee details who got second maximum incentive in January 2019. 
SELECT e.empno, e.ename, e.sal, e.deptno, i.incentive_amount, i.incentive_date
FROM employee e
JOIN incentives i ON e.empno = i.empno
WHERE MONTH(i.incentive_date) = 1 
  AND YEAR(i.incentive_date) = 2019
  AND i.incentive_amount = (
    SELECT MAX(incentive_amount)
    FROM incentives
    WHERE MONTH(incentive_date) = 1 
      AND YEAR(incentive_date) = 2019
      AND incentive_amount < (
        SELECT MAX(incentive_amount)
        FROM incentives
        WHERE MONTH(incentive_date) = 1 
          AND YEAR(incentive_date) = 2019
      )
  );
  
-- 8. Display those employees who are working in the same department where his manager is
-- working.
SELECT 
    e.empno AS employee_id,
    e.ename AS employee_name,
    e.deptno AS employee_deptno,
    d.dname AS department_name,
    m.ename AS manager_name,
    m.deptno AS manager_deptno
FROM employee e
JOIN employee m ON e.MGR_no = m.empno
JOIN dept d ON e.deptno = d.deptno
WHERE e.deptno = m.deptno;