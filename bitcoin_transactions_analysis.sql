CREATE TABLE bitcoin (
    trans_date                  DATE,	
    price_usd                   NUMERIC(8,3),
    code_size                   INT,
    sent_by_address             INT, 
    transactions                INT,
    mining_profitability        NUMERIC(6,4),
    sent_in_usd                 BIGINT,
    transaction_fees            NUMERIC(6,4),
    median_transaction_fee      NUMERIC(7,5),
    confirmation_time           NUMERIC(5,3),
    market_cap                  BIGINT,
    transaction_value           INT,
    median_transaction_value    NUMERIC(8,4),
    tweets                      INT,
    google_trends               NUMERIC(6,3),
    fee_to_reward               NUMERIC(5,3),
    active_addresses            INT,
    top_100_cap                 NUMERIC(5,3)
);


--------------------------------------------------------------------------------
/*				                  Query 1   	    	  		              */
--------------------------------------------------------------------------------

SELECT trans_date, CAST(code_size AS NUMERIC) / transactions AS difficulty
FROM bitcoin;

--------------------------------------------------------------------------------
/*				                  Query 2   	    	  		              */
--------------------------------------------------------------------------------

SELECT trans_date, median_transaction_fee * transactions AS daily_cost
FROM bitcoin
WHERE median_transaction_fee > 0.5;  

--------------------------------------------------------------------------------
/*				                  Query 3   	    	  		              */
--------------------------------------------------------------------------------

SELECT trans_date, CAST(sent_in_usd AS NUMERIC)/ transactions AS avg_transaction
FROM bitcoin
WHERE transactions > 400000;

--------------------------------------------------------------------------------
/*				                  Query 4   	    	  		              */
--------------------------------------------------------------------------------

SELECT CAST(ROUND(AVG(price_usd), 2) AS MONEY) AS avg_price,
CAST(ROUND(SUM(sent_in_usd), 2) AS MONEY) AS total_transaction_amount
FROM bitcoin
WHERE trans_date BETWEEN '2015-05-01' AND '2015-05-31';


--------------------------------------------------------------------------------
/*				                  Query 5   	    	  		              */
--------------------------------------------------------------------------------

SELECT CAST(MIN(market_cap) AS BIGINT) AS low_cap,
CAST(MAX(market_cap) AS BIGINT) as high_cap,
CAST(ROUND(MIN(price_usd), 2) AS NUMERIC) AS low_price_usd,
CAST(ROUND(MAX(price_usd), 2) AS NUMERIC) AS high_price_usd
FROM bitcoin;

--------------------------------------------------------------------------------
/*				                  Query 6   	    	  		              */
--------------------------------------------------------------------------------

SELECT MIN(median_transaction_fee) AS lowest_fee,
MAX(median_transaction_fee) AS highest_fee,
ROUND(AVG(median_transaction_fee), 5) AS avg_fee
FROM bitcoin
WHERE trans_date BETWEEN '2017-08-10' AND '2019-08-10';

--------------------------------------------------------------------------------
/*				                  Query 7   	    	  		              */
--------------------------------------------------------------------------------

SELECT AVG(transactions) AS avg_transactions,
AVG(sent_by_address) AS avg_sent_addresses
FROM bitcoin
WHERE transactions > 350000;

--------------------------------------------------------------------------------
/*				                  Query 8   	    	  		              */
--------------------------------------------------------------------------------

SELECT CAST(AVG(google_trends) AS INTEGER) AS avg_google_trends,
SUM(tweets) AS total_tweets
FROM bitcoin;

--------------------------------------------------------------------------------
/*				                  Query 9   	    	  		              */
--------------------------------------------------------------------------------

SELECT CAST(MIN(confirmation_time) AS NUMERIC) AS min_confirmation_time,
CAST(MAX(confirmation_time)AS NUMERIC) AS max_confirmation_time,
CAST(ROUND(AVG(confirmation_time), 3) AS NUMERIC) AS avg_confirmation_time
FROM bitcoin;

--------------------------------------------------------------------------------
/*				                  Query 10   	    	  		              */
--------------------------------------------------------------------------------

SELECT ROUND(AVG(price_usd), 2) AS avg_price_usd,
ROUND(AVG(mining_profitability), 2) AS avg_mining_profitability,
ROUND(AVG(transaction_fees), 2) AS avg_transaction_fees
FROM bitcoin
WHERE trans_date BETWEEN '2020-03-01' AND '2020-11-30'


