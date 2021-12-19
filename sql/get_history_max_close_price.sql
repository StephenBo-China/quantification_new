
DROP TABLE IF EXISTS stock_max_close_price;

CREATE TABLE IF NOT EXISTS stock_max_close_price 
(
    max_7             FLOAT   
    ,max_21           FLOAT    
    ,max_60           FLOAT    
    ,max_89           FLOAT       
    ,stock_code      VARCHAR(1000)
    ,ds              VARCHAR(1000)
)
;

INSERT INTO stock_max_close_price(max_7, max_21, max_60, max_89, stock_code, ds)
SELECT  MAX(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 6 PRECEDING) AS max_7
        ,MAX(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 20 PRECEDING) AS max_21
        ,MAX(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 59 PRECEDING) AS max_60
        ,MAX(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 88 PRECEDING) AS max_89
        ,t.stock_code AS stock_code 
        ,t.ds AS ds 
FROM 
(
SELECT  stock_code 
        ,ds 
        ,MAX(ds_datetime) AS ds_datetime
        ,MAX(open) AS open 
        ,MAX(close) AS close 
        ,MAX(high) AS high 
        ,MAX(low) AS low 
        ,MAX(volume) AS volume 
        ,MAX(money) AS money 
FROM    stock_daily_price_final 
GROUP BY stock_code, ds
) t
GROUP BY t.stock_code, t.ds
ORDER BY t.stock_code, t.ds
;
