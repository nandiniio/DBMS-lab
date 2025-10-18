show databases;
create database if not exists bank;
use bank;

create table branch(
branch_name varchar(50), branch varchar(20), assets int(10), primary key(branch_name)
);

create table bank_acc(
acc_no int(10), branch_name varchar(50), balance int(10), primary key(acc_no),
foreign key(branch_name) references branch(branch_name)
);

create table bank_customer(
customer_name varchar(15), customer_street varchar(20), customer_city varchar(20),
primary key(customer_name)
);

create table depositer(
customer_name varchar(15), acc_no int(10), 
foreign key(customer_name) references bank_customer(customer_name),
foreign key(acc_no) references bank_acc(acc_no)
);

create table loan(
loan_no int(5), branch_name varchar(50), amt int(10),
foreign key(branch_name) references branch(branch_name)
);

insert into branch
values ("SBI_Chamrajpet", "Bangalore",50000);
insert into branch
values ("SBI_ResidencyRoad", "Bangalore",10000);
insert into branch
values ("SBI_ShivajiRoad", "Bombay",20000);
insert into branch
values ("SBI_ParliamentRoad", "Delhi",10000);
insert into branch
values ("SBI_Jantarmantar", "Delhi",20000);

select * from branch;

insert into bank_acc
values(1, "SBI_Chamrajpet", 2000);
insert into bank_acc
values(2, "SBI_ResidencyRoad", 5000);
insert into bank_acc
values(3, "SBI_ShivajiRoad", 6000);
insert into bank_acc
values(4, "SBI_ParliamentRoad", 9000);
insert into bank_acc
values(5, "SBI_Jantarmantar", 8000);
insert into bank_acc
values(6, "SBI_ShivajiRoad", 4000);
insert into bank_acc
values(8, "SBI_ResidencyRoad", 4000);
insert into bank_acc
values(9, "SBI_ParliamentRoad", 3000);
insert into bank_acc
values(10, "SBI_ResidencyRoad", 5000);
insert into bank_acc
values(11, "SBI_Jantarmantar", 2000);

select * from bank_acc;

insert into bank_customer
values("Avinash", "Bull_temple_road", "Bangalore");
insert into bank_customer
values("Dinesh", "Bannergatta_Road", "Bangalore");
insert into bank_customer
values("Mohan", "NationalCollege_Road", "Bangalore");
insert into bank_customer
values("Nikil", "Akbar_Road", "Delhi");
insert into bank_customer
values("Ravi", "Prithviraj_Road", "Delhi");

select * from bank_customer;

insert into depositer
values("Avinash", 1);
insert into depositer
values("Dinesh", 2);
insert into depositer
values("Nikil", 4);
insert into depositer
values("Ravi", 5);
insert into depositer
values("Avinash", 8);
insert into depositer
values("Nikil", 9);
insert into depositer
values("Dinesh", 10);
insert into depositer
values("Nikil", 11);

select * from depositer;

insert into loan
values(1, "SBI_Chamrajpet", 1000);
insert into loan
values(2, "SBI_ResidencyRoad", 2000);
insert into loan
values(3, "SBI_ShivajiRoad", 3000);
insert into loan
values(4, "SBI_ParliamentRoad", 4000);
insert into loan
values(5, "SBI_Jantarmantar", 5000);

select * from loan;

-- Display the branch name and assets from all branches in lakhs of rupees and rename
-- the assets column to 'assets in lakhs'.
select branch_name, (assets/100000) as 'assets in lakhs' from branch;

-- Find all the customers who have at least two accounts at the same branch (ex.
-- SBI_ResidencyRoad).
select d.customer_name, a.branch_name from depositer d, bank_acc a
where d.acc_no = a.acc_no
group by d.customer_name, a.branch_name
having count(*) >= 2;

-- CREATE A VIEW WHICH GIVES EACH BRANCH, THE SUM OF THE
-- AMOUNT OF ALL THE LOANS AT THE BRANCH.
create view sum
as select branch_name, sum(amt) from loan group by branch_name;
select * from sum;

-- find all the customers who have an account at all the branches located in a specific city (ex : delhi)
alter table bank_acc add column customer_name varchar(15) after branch_name, add constraint fk_acc_customer
foreign key(customer_name) references bank_customer(customer_name);

update bank_acc a
join depositer d on a.acc_no = d.acc_no
set a.customer_name = d.customer_name
where a.customer_name is null or TRIM(a.customer_name) = '';

select a.customer_name from bank_customer a
join bank_acc c on a.customer_name = c.customer_name
join branch b on c.branch_name = b.branch_name
where b.branch = 'Delhi' group by a.customer_name having COUNT(distinct b.branch_name) = (select COUNT(*) from branch where branch = 'Delhi');
select branch_name, assets from branch where LOWER(branch) = 'bangalore';

-- find the names of all branches that have greater assets than all the branches in bangalore
select b.branch_name, b.assets from branch b where assets > all (select assets from branch where lower(branch) = 'bangalore' and assets is not null);

-- find all customers who have an account and a loan at the bangalore branch
select distinct(a.customer_name) from bank_customer a, depositer b where a.customer_name = b.customer_name and a.customer_city = 'Delhi';

-- update the balance of all accounts by 5%
update bank_acc
set balance = balance * 1.05;
select * from bank_acc;

-- demonstrate how you delete all account tuples at every branch located in a specific city (ex - bombay)
delete from bank_acc where branch_name in (select branch_name from branch where lower(branch) = 'bombay');
select * from bank_acc;

-- find customers who have a loan but not an account
alter table loan
add column customer_name VARCHAR(15),
add constraint fk_loan_customer foreign key (customer_name)
references bank_customer(customer_name);

select distinct l.customer_name from loan l
where not exists (select * from bank_acc a where a.customer_name = l.customer_name);