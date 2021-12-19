
DROP TABLE IF EXISTS stock_volume_avg;

CREATE TABLE IF NOT EXISTS stock_volume_avg 
(
    avg_7             FLOAT   
    ,avg_21           FLOAT    
    ,avg_60           FLOAT    
    ,avg_89           FLOAT       
    ,stock_code      VARCHAR(1000)
    ,ds              VARCHAR(1000)
)
;

INSERT INTO stock_volume_avg(avg_7, avg_21, avg_60, avg_89, stock_code, ds)
SELECT  AVG(t.volume) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 6 PRECEDING) AS avg_7
        ,AVG(t.volume) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 20 PRECEDING) AS avg_21
        ,AVG(t.volume) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 59 PRECEDING) AS avg_60
        ,AVG(t.volume) OVER (PARTITION BY t.stock_code ORDER BY t.ds ROWS 88 PRECEDING) AS avg_89
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
