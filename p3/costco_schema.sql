CREATE TABLE Warehouse(
    wid INT PRIMARY KEY,
    address TEXT NOT NULL,
    phone_number TEXT NOT NULL
);

CREATE TABLE Product(
    sku VARCHAR(30) PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    current_unit_price NUMERIC(10,2) NOT NULL
);


CREATE TABLE MembershipTier(
    tier VARCHAR PRIMARY KEY,
    yearly_cost NUMERIC(10,2) NOT NULL,
    discount_rate NUMERIC(5,2) NOT NULL CHECK (discount_rate >= 0 AND discount_rate <= 1)
);

INSERT INTO MembershipTier(tier, yearly_cost, discount_rate) VALUES
    ('Basic', 60.00, 0.00),
    ('Executive', 120.00, 0.02);


CREATE TABLE Member(
    member_id INT PRIMARY KEY,
    name TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    tier VARCHAR NOT NULL,
    FOREIGN KEY (tier) REFERENCES MembershipTier(tier)
);


CREATE TABLE InventoryBatch(
    batch_id INT PRIMARY KEY,
    wid INT NOT NULL,
    sku VARCHAR NOT NULL,
    arrival_date DATE NOT NULL,
    expiration_date DATE,
    quantity_remaining INT NOT NULL,
    FOREIGN KEY (wid) REFERENCES Warehouse(wid),
    FOREIGN KEY (sku) REFERENCES Product(sku)
);


CREATE TABLE OverallTransaction(
    tid INT PRIMARY KEY,
    t_timestamp TIMESTAMP NOT NULL,
    member_id INT NOT NULL,
    wid INT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (wid) REFERENCES Warehouse(wid)
);


CREATE TABLE TransactionItem(
    tid INT,
    batch_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price_paid NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (tid, batch_id),
    FOREIGN KEY (tid) REFERENCES OverallTransaction(tid),
    FOREIGN KEY (batch_id) REFERENCES InventoryBatch(batch_id)
);

CREATE TABLE PriceHistory(
    sku VARCHAR NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    price NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (sku, start_time),
    FOREIGN KEY (sku) REFERENCES Product(sku)
);

CREATE TABLE DailyInventory(
    inventory_date DATE NOT NULL,
    wid INT NOT NULL,
    sku VARCHAR NOT NULL,
    batch_id INT NOT NULL,
    quantity_remaining INT NOT NULL,
    PRIMARY KEY (inventory_date, batch_id),
    FOREIGN KEY (wid) REFERENCES Warehouse(wid),
    FOREIGN KEY (sku) REFERENCES Product(sku),
    FOREIGN KEY (batch_id) REFERENCES InventoryBatch(batch_id)
);

-- I used AI to generate arbitrary values to insert into the database for part d's testing: 
INSERT INTO Warehouse VALUES
(1,'100 Seattle Way','206-555-1000'),
(2,'55 Bellevue Ave','425-555-2000'),
(3,'77 Portland Rd','503-555-3000'),
(4,'12 San Jose Blvd','408-555-4000'),
(5,'9 Oakland St','510-555-5000');

INSERT INTO Product VALUES
('SKU1','Kirkland Paper Towels','Grocery',22.99),
('SKU2','Kirkland Coffee','Grocery',18.49),
('SKU3','Kirkland Olive Oil','Grocery',24.99),
('SKU4','Samsung TV','Electronics',899.99),
('SKU5','AirPods Pro','Electronics',249.99),
('SKU6','Kirkland Almonds','Grocery',12.99),
('SKU7','Kirkland Laundry Detergent','Household',19.99),
('SKU8','Kirkland Batteries','Electronics',14.99),
('SKU9','Kirkland Protein Bars','Grocery',17.99),
('SKU10','Dyson Vacuum','Electronics',499.99);

INSERT INTO Member VALUES
(1,'Alice Chen','555-1001','Basic'),
(2,'Bob Martinez','555-1002','Basic'),
(3,'Carla Singh','555-1003','Executive'),
(4,'David Kim','555-1004','Basic'),
(5,'Emily Johnson','555-1005','Executive'),
(6,'Frank Li','555-1006','Basic'),
(7,'Grace Taylor','555-1007','Executive'),
(8,'Hassan Ali','555-1008','Basic'),
(9,'Isabella Garcia','555-1009','Basic'),
(10,'Jack Brown','555-1010','Executive'),
(11,'Kevin White','555-1011','Basic'),
(12,'Laura Green','555-1012','Executive');

INSERT INTO InventoryBatch VALUES
(101,1,'SKU1','2025-12-01','2026-06-01',0),
(102,1,'SKU1','2025-12-05','2026-06-05',0),
(103,1,'SKU2','2025-12-03','2026-05-01',50),
(104,2,'SKU1','2025-12-04','2026-06-01',20),
(105,2,'SKU3','2025-11-25','2026-07-01',40),
(106,3,'SKU4','2025-12-02',NULL,10),
(107,3,'SKU5','2025-12-02',NULL,25),
(108,4,'SKU6','2025-11-20','2026-04-01',0),
(109,4,'SKU6','2025-11-28','2026-04-10',0),
(110,5,'SKU7','2025-12-01',NULL,15),
(111,5,'SKU8','2025-12-01',NULL,60),
(112,2,'SKU9','2025-12-05','2026-03-01',30),
(113,3,'SKU10','2025-12-06',NULL,8);

INSERT INTO OverallTransaction VALUES
(201,'2024-01-15 10:00:00',1,1),
(202,'2024-02-10 11:30:00',1,2),
(203,'2024-03-05 09:45:00',2,1),
(204,'2024-04-18 13:10:00',3,3),
(205,'2024-05-20 16:30:00',4,4),
(206,'2024-06-10 15:20:00',5,5),
(207,'2024-07-08 12:00:00',6,2),
(208,'2024-08-15 18:00:00',7,3),
(209,'2024-09-12 14:30:00',8,1),
(210,'2024-10-22 17:10:00',9,2),
(211,'2024-11-02 11:50:00',1,3),
(212,'2024-11-15 10:30:00',10,4),
(213,'2024-12-01 19:00:00',11,5),
(215, '2024-12-20 12:00:00', 1, 4),
(214,'2024-12-10 13:45:00',12,2);


INSERT INTO TransactionItem VALUES
(201,103,2,18.49),
(201,104,3,22.99),
(202,105,5,24.99),
(203,103,1,18.49),
(204,106,1,899.99),
(205,108,4,12.99),
(206,110,2,19.99),
(207,112,3,17.99),
(208,113,1,499.99),
(209,103,6,18.49),
(210,112,4,17.99),
(211,106,1,899.99),
(212,107,2,249.99),
(213,111,5,14.99),
(215, 113, 4, 499.99),
(214,103,3,18.49);

INSERT INTO PriceHistory VALUES
('SKU1','2025-01-01',NULL,22.99),
('SKU2','2025-01-01',NULL,18.49),
('SKU3','2025-01-01',NULL,24.99),
('SKU4','2025-01-01',NULL,899.99),
('SKU5','2025-01-01',NULL,249.99),
('SKU6','2025-01-01',NULL,12.99),
('SKU7','2025-01-01',NULL,19.99),
('SKU8','2025-01-01',NULL,14.99),
('SKU9','2025-01-01',NULL,17.99),
('SKU10','2025-01-01',NULL,499.99);

INSERT INTO DailyInventory VALUES
('2025-12-18', 1, 'SKU1', 101, 0),
('2025-12-19', 1, 'SKU1', 101, 0),
('2025-12-20', 1, 'SKU1', 101, 0),
('2025-12-21', 1, 'SKU1', 101, 0),
('2025-12-22', 1, 'SKU1', 101, 0),
('2025-12-23', 1, 'SKU1', 101, 0),
('2025-12-24', 1, 'SKU1', 101, 0);

