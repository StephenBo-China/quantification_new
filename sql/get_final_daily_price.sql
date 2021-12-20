CREATE TABLE IF NOT EXISTS stock_daily_price_final 
(
    stock_code      VARCHAR(1000)
    ,ds             VARCHAR(1000)
    ,ds_datetime    DATE  
    ,open           FLOAT
    ,close          FLOAT
    ,high           FLOAT
    ,low            FLOAT
    ,volume         FLOAT
    ,money          FLOAT
)
;

INSERT INTO stock_daily_price_final(stock_code, ds, ds_datetime, open, close, high, low, volume, money)
SELECT  t1.stock_code AS stock_code 
        ,t1.ds AS ds 
        ,str_to_date(t1.ds, "%Y-%m-%d %H:%i:%S") AS ds_datetime 
        ,t1.open AS open 
        ,t1.close AS close
        ,t1.high AS high
        ,t1.low AS low
        ,t1.volume AS volume
        ,t1.money AS money
FROM 
(
    SELECT  stock_code 
            ,ds 
            ,MAX(open) AS open 
            ,MAX(close) AS close 
            ,MAX(high) AS high 
            ,MAX(low) AS low 
            ,MAX(volume) AS volume 
            ,MAX(money) AS money 
    FROM    stock_daily_price_tmp 
    WHERE   ds >= "2021-12-01"
    GROUP BY stock_code, ds 
    ORDER BY ds 
) t1 
LEFT OUTER JOIN
(
    SELECT  stock_code
            ,ds
    FROM    stock_daily_price_final
    WHERE   ds >= "2021-12-01"
    GROUP BY stock_code, ds 
) t2 ON t1.stock_code = t2.stock_code AND t1.ds = t2.ds  
WHERE t2.stock_code IS NULL AND t2.ds IS NULL
;