-- TABLES --------------------------------------------------------------------
CREATE TABLE Customer (
  cID INT PRIMARY KEY,
  name VARCHAR(50),
  phone VARCHAR(20)
);

CREATE TABLE Product (
  pID INT PRIMARY KEY,
  name VARCHAR(50),
  price DECIMAL(10, 2),
  type VARCHAR(50)
);

CREATE TABLE Purchase (
  purchaseID INT PRIMARY KEY,
  customer INT,
  date DATE,
  total_amount DECIMAL(10, 2),
  FOREIGN KEY (customer) REFERENCES Customer(cID)
);

CREATE TABLE Purchase_Detail (
  purchase INT,
  product INT,
  quantity INT,
  FOREIGN KEY (purchase) REFERENCES Purchase(purchaseID),
  FOREIGN KEY (product) REFERENCES Product(pID)
);
-- Inserting records into the Customer table
INSERT INTO Customer (cID, name, phone)
VALUES (1, 'John Doe', '123-456-7890'),
       (2, 'Jane Smith', '987-654-3210'),
       (3, 'Michael Johnson', '555-123-4567');

-- Inserting records into the Product table
INSERT INTO Product (pID, name, price, type)
VALUES (1, 'T-Shirt', 19.99, 'Apparel'),
       (2, 'Headphones', 49.99, 'Electronics'),
       (3, 'Running Shoes', 79.99, 'Footwear'),
       (4, "Vacuum", 59.99, "Electronics");

-- Inserting records into the Purchase table
INSERT INTO Purchase (purchaseID, customer, date, total_amount)
VALUES (1, 1, '2023-05-15', 39.98),
       (2, 2, '2023-05-20', 129.98),
       (3, 3, '2023-05-22', 159.98),
        (5, 2, '2023-11-20', 100.24);


-- Inserting records into the Purchase_Detail table
INSERT INTO Purchase_Detail (purchase, product, quantity)
VALUES (1, 1, 2),
       (2, 2, 1),
       (3, 3, 2),
         (5, 3, 3);

-- SOLUTIONS -----------------------------------------------------------------

-- a) Find the customers that haven’t make any purchase. Show the customer ID and name.
SELECT c.cID, c.name
FROM Customer c
WHERE c.cID NOT IN (
SELECT c.cID 
FROM Customer c, Purchase p
WHERE c.cID = p.customer);

-- b) Which product is most expensive? Show product ID, name and price.
select p.pID, p.name, p.price
FROM Product p
WHERE p.price = (
SELECT MAX(price)
FROM Product
  );

-- c) Which products have the highest total quantity purchased? Show the product name and the number purchased.
SELECT product, SUM(quantity)
FROM Purchase_Detail
GROUP BY Product
HAVING SUM(quantity) >= ( 
  SELECT MAX(total) 
  FROM (
  	SELECT SUM(quantity) as total 
	FROM Purchase_Detail
	GROUP BY Product
    )
  )

—-- d) Calculate the total amount of each purchase (the total amount column currently has no value). Show purchase ID and total amount.
SELECT pd.purchase, pd.quantity * p.price as total_amount
from Purchase_Detail pd, Product p
WHERE pd.product = p.pID
GROUP by pd.purchase;

—-- e) Find the products that haven’t been purchased since 2023-06-01. Show the product ID and name.
SELECT p.pID, p.name
FROM Purchase pc, Purchase_Detail pcd, Product p
WHERE pc.purchaseID = pcd.purchase 
and pcd.product = p.pID
AND pc.date >= "2023-06-01"
GROUP By pc.purchaseid;

-- f) Find the total sale of November 2023.
SELECT SUM(total_amount)
from (
  SELECT pcd.quantity * p.price as total
  FROM Purchase pc, Purchase_Detail pcd, Product p
  WHERE pc.purchaseID = pcd.purchase
      AND pcd.product = p.pID
      AND pc.date BETWEEN "2023-11-01" AND "2023-11-30"
  GROUP by pc.purchaseID
  )

-- g) Find the average price of each product type. Show product type and average price
SELECT type, AVG(price)
FROM Product 
GROUP By type;

-- h) Show the product type that has average price less than average price of all product
SELECT type, AVG(price)
FROM Product 
GROUP By type
HAVING AVG(price) < (
  SELECT AVG(price)
	FROM Product 
  );
