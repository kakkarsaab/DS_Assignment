/*                      
                         MYSQL ASSIGNMENT
*/

/*
Task 1: Understanding the Data In handler
 A. Describe the data in hand in your own words. (Word Limit is 500)
 
 Ans:- The database contains the Sales Data of the Superstore market. 
	The database contains five tables:-
    1. cust_dimen -> The file gives us information about the customers
       in the superstore.
       
       Customer_Name :  Name of the customer
	    Province : Province of the customer
        Region : Region/Place of the customer to which they belong
        Customer_Segment : Segment of the customer
        Cust_id :  Customer Unique ID
        
    2.  market_fact -> This file contains the market for all the 
		product customers and the orders.
        
        Ord_id : Order ID
        Prod_id : Product ID
        Ship_id : Shipment ID
        Cust_id : Customer ID
        Order_Quantity : Order Quantity for the Item sold
        Profit : Profit from the Item 
		Sales : Total Sales Of the Item
        Discount : Discount on the Item sold
        Shipping_Cost : Shipping Cost of the Item sold
        Product_Base_Margin : Product Base Margin on the Item sold
        
        3. shipping_dimen -> This file contains the shipping details.
         
		Order_ID : Order ID
        Ship_Mode : Shipping Mode
        Ship_Date : Shipping Date
        Ship_id :  Shipment ID of the Item(Can be Unique)
        
        4. prod_dimen -> This file contains the products which are avialable 
           in the superstore market.alter
           
		Product_Category : Product Category
		Product_Sub_Category : Product Sub Category
        Prod_id :  Product ID(Unique)
        
        5. orders_dimen -> This is the file which contains details about the 
		   orders.
           
		Order_ID : Order ID
        Order_Date : Order Date
        Order_Priority: Priority of the Order
        Ord_id : Unique Order ID (Unique)
        
        From this database we can derive various insights and useful things.
        
   B. Identify and list the Primary Keys and Foreign Keys for thisdataset
   (Hint: If a table don’t have Primary Key or Foreign Key,
   then specifically mention it in your answer.)
   
   Ans: - 1.cust_dimen->
          Primary Key:- Cust_Id
          Foreign Key:- No Foreign Key Availabale (NA)
          
          2.market_fact
          Primary Key:- No Primary Key Available (NA)
          Foreign Key:- Ord_id, Prod_id, Ship_id, Cust_id
          
          3. orders_dimen->
          Primary Key:- Ord_id 
          Foreign Key:- No Foreign Key Avaialble
          
          4. prod_dimen->
          Primary Key:- Prod_id
          Foreign Key:- No Foreign Key Available (NA)
          
          5. shipping_dimen->
          Primary Key:- Ship_id
          Foreign Key:- Order_ID
          
*/

/* 
Task 2: Basic Analysis 
Write the SQL queries for the following:  

*/


# A. Find the total and the average sales (display total_sales and avg_sales)  
 #Ans:-
 
SELECT SUM(sales) AS total_sales, AVG(sales) AS avg_sales FROM market_fact;

# B. Display the number of customers in each region in decreasing order of no_of_customers. 
#The result should contain columns Region, no_of_customers
#Ans:-

 SELECT 
    Region, COUNT(*) AS no_of_customers
	FROM
    cust_dimen
	GROUP BY Region
    ORDER BY no_of_customers DESC
    
# C. Find the region having maximum customers (display the region name and max(no_of_customers) 
# Ans:-

SELECT 
    Region, COUNT(*) AS Number_of_Customers
	FROM
    cust_dimen
	GROUP BY Region
	HAVING 
    Number_of_Customers >= ALL (SELECT 
									COUNT(*) AS Number_of_Customers
									FROM
									cust_dimen
									GROUP BY region )

# D. Find the number and id of products sold in decreasing order of products sold
# (display product id, no_of_products sold) 
#Ans:-

SELECT 
    prod_id AS Product_Id, COUNT(*) AS Products_Sold
	FROM
    market_fact
	GROUP BY prod_id
	ORDER BY Products_Sold DESC
    
#5. Find all the customers from Atlantic region who have ever 
# purchased ‘TABLES’ and the number of tables purchased 
# (display the customer name, no_of_tables purchased) 

SELECT 
    cust.customer_name, COUNT(*) AS Number_of_tables_purchased
	FROM
    market_fact mar
	INNER JOIN
    cust_dimen cust ON mar.cust_id = cust.cust_id
	WHERE
    cust.region = 'atlantic'
	AND mar.prod_id = ( SELECT 
							prod_id
							FROM
							prod_dimen
							WHERE
							product_sub_category = 'Tables'	)
	Group By mar.cust_id, cust.customer_name
    
/*
    Task 3: Advanced Analysis 
    Write sql queries for the following: 
*/

#A. Display the product categories in descending order of profits?
 #(display the product category wise profits i.e. product_category, profits)
 #Ans:-
 
 SELECT 
    prod.product_category, SUM(mar.profit) AS profits
	FROM
    market_fact mar
	INNER JOIN
    prod_dimen prod ON mar.prod_id = prod.prod_id
	GROUP BY prod.product_category
	ORDER BY profits DESC
    
#B. Display the product category, product sub-category 
# and the profit within each subcategory in three columns.  
# Ans:-

SELECT 
    prod.product_category, prod.product_sub_category, SUM(mar.profit) AS total_profits
	FROM
    market_fact mar
	INNER JOIN
    prod_dimen prod ON mar.prod_id = prod.prod_id
	GROUP BY prod.product_category, prod.product_sub_category
 
/*C. Where is the least profitable product subcategory shipped the most?
 For the least profitable product sub-category,  
 display the  region-wise no_of_shipments 
 and the profit made in each region in decreasing order of profits 
 (i.e. region, no_of_shipments, profit_in_each_region) 
 o Note: You can hardcode the name of the least profitable product subcategory
 
 */
 
 #Ans:-
 
 SELECT
 cust.Region as "Region", count(mar.Ship_id) as "No of Shipments", 
		SUM(mar.Profit) as "Profit done in each region"
FROM market_fact mar 
		JOIN cust_dimen cust on mar.Cust_id = cust.Cust_id
        JOIN prod_dimen prod on mar.Prod_id = prod.Prod_id
WHERE Product_Sub_Category = (
				SELECT prod.Product_Sub_Category 
				FROM market_fact mar 
					JOIN prod_dimen prod on mar.Prod_id = prod.Prod_id
					group by Product_Sub_Category
					order by SUM(mar.Profit)
					LIMIT 1) 
group by cust.Region
order by SUM(mar.Profit);

/* 
                            END - THANK YOU 
*/
 