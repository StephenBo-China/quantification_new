
CREATE TABLE IF NOT EXISTS stock_ma21_ma89_rule_base_table
(
    ma_21             FLOAT   
    ,ma_89            FLOAT  
    ,volume_avg_89    FLOAT   
    ,open             FLOAT    
    ,close            FLOAT   
    ,volume           FLOAT    
    ,stock_code       VARCHAR(1000)
    ,ds               VARCHAR(1000)
)
;

INSERT INTO stock_ma21_ma89_rule_base_table(ma_21, ma_89, volume_avg_89, open, close, volume, stock_code, ds)
SELECT  a1.ma_21 AS ma_21 
        ,a1.ma_89 AS ma_89
        ,a1.volume_avg_89 AS volume_avg_89
        ,a1.open AS open
        ,a1.close AS close
        ,a1.volume AS volume
        ,a1.stock_code AS stock_code
        ,a1.ds AS ds
FROM    
(
    SELECT  t2.ma_21 AS ma_21 
            ,t2.ma_89 AS ma_89 
            ,t3.avg_89 AS volume_avg_89
            ,t1.open AS open 
            ,t1.close AS close 
            ,t1.volume AS volume 
            ,t1.stock_code AS stock_code 
            ,t1.ds AS ds 
    FROM    
    (
        SELECT  MAX(open) AS open 
                ,MAX(close) AS close 
                ,MAX(volume) AS volume  
                ,stock_code 
                ,ds 
        FROM    stock_daily_price_final
        WHERE   ds >= "2021-12-01" 
        GROUP BY stock_code, ds 
    ) t1 
    LEFT OUTER JOIN 
    (   
        SELECT  MAX(ma_21) AS ma_21 
                ,MAX(ma_89) AS ma_89 
                ,stock_code 
                ,ds 
        FROM    stock_ma_value 
        WHERE   ds >= "2021-12-01"
        GROUP BY stock_code, ds 
    ) t2 ON t1.stock_code = t2.stock_code AND t1.ds = t2.ds
    LEFT OUTER JOIN 
    (
        SELECT  MAX(avg_89) AS avg_89
                ,stock_code 
                ,ds 
        FROM    stock_volume_avg 
        WHERE   ds >= "2021-12-01"
        GROUP BY stock_code, ds 
    ) t3 ON t1.stock_code = t3.stock_code AND t1.ds = t3.ds 
) a1 
LEFT OUTER JOIN 
(
    SELECT  stock_code
            ,ds 
    FROM    stock_ma21_ma89_rule_base_table
    WHERE   ds >= "2021-12-01"
    GROUP BY stock_code, ds 
) a2 ON a1.stock_code = a2.stock_code AND a1.ds = a2.ds 
WHERE a2.stock_code IS NULL AND a2.ds IS NULL
;