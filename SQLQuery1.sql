Select top 10 * from apnaklub.dbo.apnaklub_data_2;

--Task-1  Add Seeling Price Column

--Adding the coloumn in the table where we store the data
Alter table apnaklub.dbo.apnaklub_data_2
add selling_prices float;

--Updating the values inside the selling_prices column that we created above.
update apnaklub.dbo.apnaklub_data_2
set  selling_prices = placed_gmv/quantity;

--Task-2 Now we format the order_date coloumns

ALTER TABLE apnaklub_data_2
ADD order_date_coverted date;

UPDATE apnaklub_data_2
SET order_date_coverted = CONVERT(date, order_date);

ALTER TABLE apnaklub_data_2
DROP COLUMN order_date

select * from apnaklub_data_2;


--Task-3 Lets find average order value
SELECT 
    CAST(SUM(placed_gmv) AS FLOAT) / COUNT(DISTINCT order_id) AS average_order_value
FROM apnaklub.dbo.apnaklub_data_2;

select placed_gmv from apnaklub_data_2
where USER_id='864cd3a'


-- Task-4 GMV PER CUSTOMER
SELECT 
    user_id, 
    SUM(placed_gmv) AS total_gmv
FROM apnaklub.dbo.apnaklub_data_2
GROUP BY user_id
ORDER BY total_gmv DESC;


-- Task-5 Total Orders
select count(distinct order_id) as total_orders  from apnaklub.dbo.apnaklub_data_2;


-- Task-6 Total orders gmv by month and country
SELECT 
    FORMAT(order_date_coverted, 'yyyy-MM') AS month,
    warehouse_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(placed_gmv) AS total_gmv
FROM apnaklub.dbo.apnaklub_data_2
GROUP BY FORMAT(order_date_coverted, 'yyyy-MM'), warehouse_name
ORDER BY month, warehouse_name;


-- Task-7 Show the list number of customers who have transacted in more than 1 warehouse
--and in additional show all the warehouses in an array and another column the most
--recent warehouse by order date [ SQL query ]
--There is no user in the database that is affiliated with more than one Warehouse
SELECT 
    user_id,
    COUNT(DISTINCT warehouse_name) AS warehouse_count
FROM apnaklub.dbo.apnaklub_data_2
GROUP BY user_id
ORDER BY warehouse_count desc;-- The qurey to represent all warehouse in an array AND TOTAL ORDER PLACED BY WAREHOUSEselect  Distinct warehouse_name,count(placed_gmv) as Total_GMV_Placed  from apnaklub_data_2 group by warehouse_name;-- Most Recent Warehouse accessed by recent dateSELECT 
    user_id,
    warehouse_name AS most_recent_warehouse,
    order_date_coverted AS recent_date
FROM (
    SELECT 
        user_id,
        warehouse_name,
        order_date_coverted,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY TRY_CAST(order_date_coverted AS DATE) DESC
        ) AS rn
    FROM apnaklub.dbo.apnaklub_data_2
) ranked
WHERE rn = 1;



















