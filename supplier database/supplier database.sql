show databases;
create database supplier_new;
use supplier_new;

create table supplier(
SID int(10), sname varchar(20), city varchar(20),
primary key(SID)
);

create table parts(
PID int(10), pname varchar(20), pcolor varchar(10),
primary key(PID)
);

create table catalog(
SID int(10), PID int(10), cost int(10),
foreign key (SID) references supplier(SID),
foreign key (PID) references parts(PID)
);

insert into supplier(SID, sname, city) values
(575, "Acme Widget", "Bangalore"),
(103, "Trader company", "Mumbai"),
(234, "ABC suppliers", "Hyderabad"),
(453, "XYZ suppliers", "Bangalore");

insert into parts(PID, pname, pcolor) values
(123, "Fan blades", "Red"),
(789, "Keyboard", "Black"),
(342, "Faucet", "Silver"),
(124, "Fan blades", "White"),
(790, "Keyboard", "Red");

insert into parts(PID, pname, pcolor) values
(791,"Battery", "Black"),
(792,"Battery", "White");

insert into catalog (SID,PID,cost) values
(575, 123, 15000),
(575, 342, 10000),
(234, 342, 14000),
(103, 789, 20000),
(103, 790, 25000),
(234, 124, 10000),
(234, 123, 13000),
(575, 124, 17000),
(453, 789, 18000),
(453, 790, 22000),
(453, 791, 30000),
(103, 791, 28000),
(103, 792, 32000),
(453, 792, 34000);

-- Find the pnames of parts for which there is some supplier.
select distinct P.pname
from Parts P
where P.pid in ( select C.pid from Catalog C);

-- Find the snames of suppliers who supply every part.
SELECT S.sname
FROM supplier S WHERE NOT EXISTS (SELECT P.pid FROM parts P WHERE P.pid NOT IN (
        SELECT C.pid FROM catalog C WHERE C.sid = S.sid)
);

-- Find the snames of suppliers who supply every red part.
select s.sname from supplier s where not exists(select p.pid from parts p where p.pid not in(
select c.pid from catalog c where c.sid = s.sid) and p.pcolor = "Red");

-- Find the pnames of parts supplied by Acme Widget Suppliers and by no
-- one else.
SELECT P.pname
FROM parts P
JOIN catalog C ON P.pid = C.pid
JOIN supplier S ON C.sid = S.sid
WHERE S.sname = 'Acme Widget Suppliers'
  AND P.pid NOT IN (
      SELECT C2.pid
      FROM catalog C2
      JOIN supplier S2 ON C2.sid = S2.sid
      WHERE S2.sname = 'Acme Widget Suppliers'
  );

-- Find the sids of suppliers who charge more for some part than the average
-- cost of that part (averaged over all the suppliers who supply that part).
SELECT c.sid
FROM catalog c
where c.cost > (select avg(c2.cost) from catalog c2 where c.pid = c2.pid);

-- For each part, find the sname of the supplier who charges the most for
-- that part.
SELECT S.sname, p.pname
FROM supplier S
join catalog C ON S.sid = C.sid
join parts p on p.pid = C.pid
WHERE C.cost = (
   SELECT MAX(C2.cost)
   FROM catalog C2
   WHERE C2.pid = C.pid
);
