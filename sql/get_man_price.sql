CREATE TABLE IF NOT EXISTS stock_ma_value 
(
    ma_7             FLOAT   
    ,ma_21           FLOAT    
    ,ma_60           FLOAT    
    ,ma_89           FLOAT       
    ,stock_code      VARCHAR(1000)
    ,ds              VARCHAR(1000)
)
;

INSERT INTO stock_ma_value(ma_7, ma_21, ma_60, ma_89, stock_code, ds)
SELECT  t1.ma_7 AS ma_7 
        ,t1.ma_21 AS ma_21 
        ,t1.ma_60 AS ma_60 
        ,t1.ma_89 AS ma_89
        ,t1.stock_code AS stock_code 
        ,t1.ds AS ds 
FROM 
(
    SELECT  AVG(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 6 PRECEDING) AS ma_7
            ,AVG(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 20 PRECEDING) AS ma_21
            ,AVG(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 59 PRECEDING) AS ma_60
            ,AVG(t.close) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 88 PRECEDING) AS ma_89
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
        WHERE   ds >= "2021-06-01"
        GROUP BY stock_code, ds
    ) t
    GROUP BY t.stock_code, t.ds
    ORDER BY t.stock_code, t.ds
) t1 
LEFT OUTER JOIN 
(
    SELECT  ds, stock_code 
    FROM    stock_ma_value
    WHERE   ds >= "2021-06-01"
    GROUP BY ds, stock_code 
) t2 ON t1.stock_code = t2.stock_code AND t1.ds = t2.ds 
WHERE t2.ds IS NULL AND t2.stock_code IS NULL
;
