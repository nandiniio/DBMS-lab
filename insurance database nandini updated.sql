show databases;
create database insurance_new;
show databases;
use insurance_new;

create table data(
driver_id varchar(3), name varchar(20), address varchar(20), primary key (driver_id)
);
insert into data (driver_id,name,address)
values("AO1", "Richard", "Srinivas Nagar");
insert into data (driver_id,name,address)
values("AO2", "Pradeep", "Rajaji Nagar");
insert into data (driver_id,name,address)
values("AO3", "Smith", "Ashok Nagar");
insert into data (driver_id,name,address)
values("AO4", "Venu", "NR Colony");
insert into data (driver_id,name,address)
values("AO5", "Jhon", "Hanumanth Nagar");

create table car(reg_num varchar(10), model varchar(20), year int(4), 
primary key (reg_num)
);
create table accident(report_num int(5), date date, location varchar(20),
primary key(report_num)
);
create table owns(driver_id varchar(3), reg_num varchar(10),
primary key (driver_id, reg_num),
foreign key(driver_id) references data(driver_id),
foreign key(reg_num) references car(reg_num)
);
create table participated(driver_id varchar(10), reg_num varchar(10), report_num int(5), damage_amt int(10),
primary key(driver_id, reg_num, report_num), 
foreign key(driver_id) references data(driver_id),
foreign key(reg_num) references car(reg_num),
foreign key(report_num) references accident(report_num)
);

insert into accident values(11, "2003-01-01", "Mysore Road");
insert into accident values(12, "2004-02-02", "South end circle");
insert into accident values(13, "2003-01-21", "Bull temple road");
insert into accident values(14, "2008-02-17", "Mysore road");
insert into accident values(15, "2004-03-05", "Kanakapura road");

insert into car values("KA052250", "Indica", 1990);
insert into car values("KA031181", "Lancer", 1957);
insert into car values("KA095477", "Toyota", 1998);
insert into car values("KA053408", "Honda", 2008);
insert into car values("KA041702", "Audi", 2005);

insert into owns values("AO1", "KA052250");
insert into owns values("AO2", "KA031181");
insert into owns values("AO3", "KA095477");
insert into owns values("AO4", "KA053408");
insert into owns values("AO5", "KA041702");

insert into participated values("AO1", "KA052250",11, 10000);
insert into participated values("AO2", "KA031181",12, 50000);
insert into participated values("AO3", "KA095477",13, 25000);
insert into participated values("AO4", "KA053408",14, 3000);
insert into participated values("AO5", "KA041702",15, 5000);


update participated set damage_amt = 25000 where reg_num = "KA031181" and report_num =12;
select * from participated;

-- Find the total number of people who owned cars that involved in accidents in 2008.
select count(distinct driver_id) CNT from participated a, accident b where a.report_num = b.report_num
and date like "%08";

-- Display the entire CAR relation in the ascending order of manufacturing year.
select * from car order by year asc;

insert into accident values(16, "2008-03-08", "Domlur");

-- Find the number of accidents in which cars belonging to a specific model (example 'Lancer') were
-- involved.
select count(model) CNT from car c, participated p, accident a where c.model = "lancer" and c.reg_num = p.reg_num and p.report_num = a.report_num;

select driver_id from participated where damage_amt >= 25000;
select * from accident;

alter table accident
rename to accidents;

select date and location from accidents;

select avg(damage_amt) from participated;

-- Q1. LIST THE ENTIRE PARTICIPATED RELATION IN THE
-- DESCENDING ORDER OF DAMAGE AMOUNT.
select * from participated order by damage_amt desc;

-- FIND THE AVERAGE DAMAGE AMOUNT
 select avg(damage_amt) from participated;
 
--  DELETE THE TUPLE WHOSE DAMAGE AMOUNT IS BELOW
-- THE AVERAGE DAMAGE AMOUNT
delete from participated where damage_amt<(select avg_damage from (select avg(damage_amt) as avg_damage from participated)as t);

-- LIST THE NAME OF DRIVERS WHOSE DAMAGE IS GREATER
-- THAN THE AVERAGE DAMAGE AMOUNT.
select name from data a, participated b where a.driver_id = b.driver_id and damage_amt>(select avg_damage from(select avg(damage_amt) as avg_damage from participated)as t);

-- FIND MAXIMUM DAMAGE AMOUNT.
select max(damage_amt) from participated;
