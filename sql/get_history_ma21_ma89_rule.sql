DROP TABLE IF EXISTS stock_ma21_ma89_rule_table 

CREATE TABLE IF NOT EXISTS stock_ma21_ma89_rule_table
(
    feature           BIGINT
    ,stock_code       VARCHAR(1000)
    ,ds               VARCHAR(1000)
)
;

INSERT INTO stock_ma21_ma89_rule_table(feature, stock_code, ds)

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
    GROUP BY stock_code, ds 
) t 
;