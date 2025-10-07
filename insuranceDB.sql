show databases;
create database insurance_new;
show databases;
use insurance_new;

create table person(
driver_id varchar(3), name varchar(20), address varchar(20), primary key (driver_id)
);
insert into person (driver_id,name,address)
values("AO1", "Richard", "Srinivas Nagar");
insert into person (driver_id,name,address)
values("AO2", "Pradeep", "Rajaji Nagar");
insert into person (driver_id,name,address)
values("AO3", "Smith", "Ashok Nagar");
insert into person (driver_id,name,address)
values("AO4", "Venu", "NR Colony");
insert into person (driver_id,name,address)
values("AO5", "Jhon", "Hanumanth Nagar");

create table car(reg_num varchar(10), model varchar(20), year int(4), 
primary key (reg_num)
);
create table accident(report_num int(5), date date, location varchar(20),
primary key(report_num)
);
create table owns(driver_id varchar(3), reg_num varchar(10),
primary key (driver_id, reg_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num)
);
create table participated(driver_id varchar(10), reg_num varchar(10), report_num int(5), damage_amt int(10),
primary key(driver_id, reg_num, report_num), 
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num),
foreign key(report_num) references accident(report_num)
);

insert into accident values(11, "2003-01-01", "Mysore Road");
insert into accident values(12, "2004-02-02", "South end circle");
insert into accident values(13, "2003-01-21", "Bull temple road");
insert into accident values(14, "2008-02-17", "Mysore road");
insert into accident values(15, "2004-03-05", "Kanakapura road");

insert into car values("KA052250", "Indica", 1990);
insert into car values("KA053408", "Lancer", 1957);
insert into car values("KA031181", "Toyota", 1998);
insert into car values("KA095477", "Honda", 2008);
insert into car values("KA041702", "Audi", 2005);

insert into owns values("AO1", "KA052250");
insert into owns values("AO2", "KA053408");
insert into owns values("AO3", "KA031181");
insert into owns values("AO4", "KA095477");
insert into owns values("AO5", "KA041702");

insert into participated values("AO1", "KA052250",11, 10000);
insert into participated values("AO2", "KA053408",12, 50000);
insert into participated values("AO3", "KA031181",13, 25000);
insert into participated values("AO4", "KA095477",14, 3000);
insert into participated values("AO5", "KA041702",15, 5000);

update participated set damage_amt = 25000 where reg_num = "KA053408" and report_num =12;
select * from participated;

select count(distinct driver_id) CNT from participated a, accident b where a.report_num = b.report_num
and b.date like "%08";

insert into accident values(16, "2008-03-08", "Domlur");

select driver_id from participated where damage_amt >= 25000;
select * from accident;

alter table accident
rename to accidents;

select date and location from accidents;

select * from participated order by damage_amt desc;

select avg(damage_amt) from participated;

DELETE FROM participated
WHERE damage_amt < ( SELECT avg_damage FROM (SELECT AVG(damage_amt) AS avg_damage FROM participated) AS t);

select * from participated;

select name from person a, participated b where a.driver_id = b.driver_id and damage_amt>(select avg(damage_amt) from participated);

select max(damage_amt) from participated;