CREATE TABLE IF NOT EXISTS stock_ma21_ma89_rule_table
(
    feature           BIGINT
    ,stock_code       VARCHAR(1000)
    ,ds               VARCHAR(1000)
)
;

INSERT INTO stock_ma21_ma89_rule_table(feature, stock_code, ds)
SELECT  t1.feature AS feature 
        ,t1.stock_code AS stock_code 
        ,t1.ds AS ds 
FROM 
(
    SELECT  CASE WHEN 
            t.open < t.ma_21 AND t.open < t.ma_89 
            AND t.close > t.ma_21 AND t.close > t.ma_89 
            AND t.volume > t.volume_avg_89 * 1.1 THEN 1 
            ELSE 0 END AS feature 
            ,t.stock_code AS stock_code  
            ,t.ds AS ds  
    FROM    
    (
        SELECT  MAX(ma_21) AS ma_21
                ,MAX(ma_89) AS ma_89
                ,MAX(volume_avg_89) AS volume_avg_89
                ,MAX(open) AS open
                ,MAX(close) AS close
                ,MAX(volume) AS volume
                ,stock_code 
                ,ds 
        FROM    stock_ma21_ma89_rule_base_table
        WHERE   ds >= "2021-12-01"
        GROUP BY stock_code, ds 
    ) t 
) t1 
LEFT OUTER JOIN 
(
    SELECT  ds, stock_code 
    FROM    stock_volume_avg
    WHERE   ds >= "2021-12-01"
    GROUP BY ds, stock_code 
) t2 ON t1.ds = t2.ds AND t1.stock_code = t2.stock_code
WHERE t2.ds IS NULL AND t2.stock_code IS NULL
;