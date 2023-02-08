CREATE DATABASE AZBank;
USE AZBank;

CREATE TABLE Customer (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(50) NOT NULL
);

CREATE TABLE CustomerAccount (
    AccountNumber VARCHAR(20) PRIMARY KEY,
    CustomerId INT FOREIGN KEY REFERENCES Customer(CustomerId),
    Balance DECIMAL(18,2) NOT NULL,
	MinAcount DECIMAL (18) NOT NULL
);

CREATE TABLE CustomerTransaction (
    TransactionId INT PRIMARY KEY IDENTITY(1,1),
    AccountNumber VARCHAR(20) FOREIGN KEY REFERENCES CustomerAccount(AccountNumber),
    TransactionDate DATETIME NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    DepositorWithdraw VARCHAR(10) NOT NULL
);
INSERT INTO Customer (Name,City, Country, Phone, Email)
VALUES 
    ('John Doe','HaNoi', 'Vietnam', '+84 123 456 789', 'johndoe@email.com'),
    ('Jane Doe','ThanhHoa', 'Vietnam', '+84 987 654 321', 'janedoe@email.com'),
    ('Bob Smith','NewYork', 'USA', '+1 123 456 789', 'bobsmith@email.com');

INSERT INTO CustomerAccount (AccountNumber, CustomerId, Balance, MinAcount)
VALUES
    ('A00000001', 1, 10000, 100),
    ('A00000002', 2, 20000, 400),
    ('A00000003', 3, 30000, 600);

INSERT INTO CustomerTransaction (AccountNumber, TransactionDate, Amount, DepositorWithdraw)
VALUES
    ('A00000001', '2022-01-01', 5000, 'deposit'),
    ('A00000002', '2022-02-01', 6000, 'withdraw'),
    ('A00000003', '2022-03-01', 7000, 'deposit');
SELECT *
FROM Customer
WHERE Country = 'Hanoi';
SELECT Name, Phone, Email, CustomerAccount.AccountNumber, Balance
FROM Customer
JOIN CustomerAccount
ON Customer.CustomerId = CustomerAccount.CustomerId;
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_Amount
CHECK (Amount > 0 AND Amount <= 1000000);
CREATE NONCLUSTERED INDEX IX_Customer_Name
ON Customer (Name);
CREATE VIEW CustomerTransactions AS
SELECT Customer.Name, CustomerAccount.AccountNumber, CustomerTransaction.TransactionDate, 
       CustomerTransaction.Amount, CustomerTransaction
CREATE PROCEDURE spAddCustomer (@CustomerId int, @CustomerName varchar(50), @Country varchar(50), @Phone varchar(50), @Email varchar(50))
AS
BEGIN
    INSERT INTO Customer (CustomerId, Name, Country, Phone, Email)
    VALUES (@CustomerId, @CustomerName, @Country, @Phone, @Email)
END
CREATE PROCEDURE spGetTransactions (@AccountNumber VARCHAR(50), @FromDate DATE, @ToDate DATE)
AS
BEGIN
    SELECT 
        c.Name, 
        t.TransactionDate, 
        t.Amount,
        (CASE 
            WHEN t.DepositorWithdraw = 1 THEN 'Deposit'
            ELSE 'Withdraw'
         END) AS TransactionType
    FROM 
        Customer c
        INNER JOIN CustomerAccount ca ON c.CustomerId = ca.CustomerId
        INNER JOIN CustomerTransaction t ON ca.AccountNumber = t.AccountNumber
    WHERE 
        ca.AccountNumber = @AccountNumber
        AND t.TransactionDate BETWEEN @FromDate AND @ToDate
END
