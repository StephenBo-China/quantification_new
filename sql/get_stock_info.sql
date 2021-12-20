SELECT  t.stock_name AS stock_name 
        ,MAX(t.stock_code) AS stock_code 
        ,MAX(t.start_date) AS start_date 
        ,MAX(t.end_date) AS end_date
FROM 
(
    SELECT  t1.stock_name AS stock_name 
            ,t1.stock_code AS stock_code 
            ,CASE WHEN t2.stock_code IS NULL THEN t1.start_date ELSE t2.ds END AS start_date 
            ,t1.end_date AS end_date 
    FROM 
    (
        SELECT  stock_name 
                ,MAX(stock_code) AS stock_code  
                ,MAX(start_date) AS start_date  
                ,MAX(end_date) AS end_date  
        FROM    stock_info 
        GROUP BY stock_name 
    ) t1
    LEFT OUTER JOIN 
    (
        SELECT  stock_code 
                ,MAX(ds) AS ds 
        FROM    stock_daily_price_tmp
        GROUP BY stock_code 
    ) t2 ON t1.stock_code = t2.stock_code 
) t
GROUP BY t.stock_name
;