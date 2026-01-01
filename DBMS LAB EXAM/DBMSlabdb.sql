show databases;
create database pharmacy;
use pharmacy;

CREATE TABLE Supplier (
    S_id INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    address VARCHAR(100),
    contact_no VARCHAR(15),
    gst_license_no VARCHAR(30)
);

CREATE TABLE Sales_Transaction (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    total_amount DECIMAL(10,2),
    discount DECIMAL(10,2)
);

CREATE TABLE Payment (
    pay_id INT PRIMARY KEY,
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_mode VARCHAR(20),
    payment_status VARCHAR(20),
    sale_id INT UNIQUE,
    FOREIGN KEY (sale_id) REFERENCES Sales_Transaction(sale_id)
);

INSERT INTO Supplier VALUES
(1, 'HealthCorp', 'Bangalore', '9000011111', 'GSTH001'),
(2, 'MediLife', 'Mumbai', '9000011112', 'GSTM002'),
(3, 'PharmaPlus', 'Delhi', '9000011113', 'GSTP003'),
(4, 'WellCare', 'Chennai', '9000011114', 'GSTW004'),
(5, 'CureAll', 'Hyderabad', '9000011115', 'GSTC005');

INSERT INTO Sales_Transaction VALUES
(201, '2025-09-01', 200.00, 10.00),
(202, '2025-09-02', 150.00, 5.00),
(203, '2025-09-03', 300.00, 0.00),
(204, '2025-09-04', 180.00, 15.00),
(205, '2025-09-05', 120.00, 0.00);

INSERT INTO Payment VALUES
(301, '2025-09-01', 190.00, 'Cash', 'Paid', 201),
(302, '2025-09-02', 145.00, 'UPI', 'Paid', 202),
(303, '2025-09-03', 300.00, 'Card', 'Paid', 203),
(304, '2025-09-04', 165.00, 'Cash', 'Paid', 204),
(305, '2025-09-05', 120.00, 'UPI', 'Paid', 205);

select * from Payment p inner join Sales_Transaction st
ON st.sale_id = p.sale_id;


update Payment
set payment_status = 'Completed'
where payment_id = 301;
select * from Payment;

delete from Sales_Transaction
where sale_id = 204;
