SELECT  t1.stock_name AS stock_name
        ,t1.stock_code AS stock_code
FROM
(
    SELECT  stock_name 
            ,MAX(stock_code) AS stock_code 
            ,MAX(name) AS name 
            ,MAX(start_date) AS start_date 
            ,MAX(end_date) AS end_date 
    FROM    stock_info 
    GROUP BY stock_name 
) t1 
LEFT OUTER JOIN 
(
    SELECT  stock_code 
    FROM    stock_daily_price_tmp 
    GROUP BY stock_code 
) t2 ON t1.stock_code = t2.stock_code 
WHERE t2.stock_code IS NULL 
; 