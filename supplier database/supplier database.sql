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

