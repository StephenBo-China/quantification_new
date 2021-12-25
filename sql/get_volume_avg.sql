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
SELECT  t1.avg_7 AS avg_7 
        ,t1.avg_21 AS avg_21 
        ,t1.avg_60 AS avg_60 
        ,t1.avg_89 AS avg_89
        ,t1.stock_code AS stock_code 
        ,t1.ds AS ds 
FROM 
(
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
        WHERE   ds >= "2021-06-01"
        GROUP BY stock_code, ds
    ) t
    GROUP BY t.stock_code, t.ds
    ORDER BY t.stock_code, t.ds
) t1 
LEFT OUTER JOIN 
(
    SELECT  ds, stock_code 
    FROM    stock_volume_avg
    WHERE   ds >= "2021-06-01"
    GROUP BY ds, stock_code
) t2 ON t1.stock_code = t2.stock_code AND t1.ds = t2.ds 
WHERE t2.ds IS NULL AND t2.stock_code IS NULL
;
