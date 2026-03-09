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


CREATE TABLE Transaction(
    tid INT PRIMARY KEY,
    t_timestamp TIMESTAMP NOT NULL,
    member_id INT NOT NULL,
    wid INT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (wid) REFERENCES Warehouse(wid)
);


CREATE TABLE TransactionItem(
    tid INT PRIMARY KEY,
    batch_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price_paid NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (tid) REFERENCES PurchaseTransaction(tid),
    FOREIGN KEY (batch_id) REFERENCES InventoryBatch(batch_id)
);

CREATE TABLE PriceHistory(
    sku VARCHAR NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    price NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (sku, start_time),
    FOREIGN KEY (sku) REFERENCES Product(sku),
);