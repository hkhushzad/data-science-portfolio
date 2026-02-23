Hi, these are the databases that I have created:

--------------------------------------------------------------------------------
/*				                 Create Database         	 		          */
--------------------------------------------------------------------------------

CREATE DATABASE banking;

--------------------------------------------------------------------------------
/*				             Connect to Database        		  	          */
--------------------------------------------------------------------------------

\connect banking;

--------------------------------------------------------------------------------
/*				                 Banking DDL           		  		          */
--------------------------------------------------------------------------------

CREATE TABLE branch (
branch_name VARCHAR(40) PRIMARY KEY,
branch_city VARCHAR(40) NOT NULL,
assets MONEY NOT NULL CHECK (assets >= '0.00'::MONEY),
CONSTRAINT branch_city_check CHECK (branch_city IN 
('Brooklyn', 'Bronx', 'Manhattan', 'Yonkers'))
);

CREATE TABLE customer (
cust_ID VARCHAR(40) PRIMARY KEY,
customer_name VARCHAR(40) NOT NULL,
customer_street VARCHAR(40) NOT NULL,
customer_city VARCHAR(40)
);

CREATE TABLE loan (
loan_number VARCHAR(40) PRIMARY KEY,
branch_name VARCHAR(40),
amount MONEY NOT NULL DEFAULT '0.00'::MONEY CHECK (amount >= '0.00'::MONEY),
CONSTRAINT branch_name_fkey FOREIGN KEY (branch_name)
REFERENCES branch(branch_name)
ON UPDATE CASCADE
ON DELETE CASCADE
);

CREATE TABLE borrower (
cust_ID VARCHAR(40),
loan_number VARCHAR(40),
PRIMARY KEY (cust_ID, loan_number),
CONSTRAINT cust_ID_fkey FOREIGN KEY (cust_ID)
REFERENCES customer(cust_ID)
ON UPDATE CASCADE
ON DELETE CASCADE,
CONSTRAINT loan_number_fkey FOREIGN KEY (loan_number)
REFERENCES loan(loan_number)
ON UPDATE CASCADE
ON DELETE CASCADE 
);

CREATE TABLE account (
account_number VARCHAR(40) PRIMARY KEY,
branch_name VARCHAR(40),
balance MONEY NOT NULL DEFAULT '0.00'::MONEY CHECK (balance >= '0.00'::MONEY), 
CONSTRAINT branch_name_fkey FOREIGN KEY (branch_name)
REFERENCES branch(branch_name)
ON UPDATE CASCADE
ON DELETE CASCADE 
);

CREATE TABLE depositor (
cust_ID VARCHAR(40),
account_number VARCHAR(40),
PRIMARY KEY (cust_ID, account_number),
CONSTRAINT cust_ID_fkey FOREIGN KEY(cust_ID)
REFERENCES customer(cust_ID)
ON UPDATE CASCADE
ON DELETE CASCADE,
CONSTRAINT account_number_fkey FOREIGN KEY(account_number)
REFERENCES account(account_number)
ON UPDATE CASCADE
ON DELETE CASCADE 
);
