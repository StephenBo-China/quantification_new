

SELECT  ds, stock_code, close
FROM    stock_daily_price_final 
WHERE   stock_code = "002368.XSHE"
AND     ds >= "2021-01-01"
AND     ds <= "2021-02-09"
;