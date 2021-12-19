
DROP TABLE IF EXISTS stock_ma_value;

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
GROUP BY stock_code, ds
) t
GROUP BY t.stock_code, t.ds
ORDER BY t.stock_code, t.ds
;
