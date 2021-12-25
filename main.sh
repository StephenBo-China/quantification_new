#!/bin/bash
source ~/.zshrc 

################[获取t-1,t-31]的日期]###################
#获取当日日期
current_date=$(date "+%Y%m%d")
python=/Users/stephenbo/opt/anaconda3/envs/quant/bin/python 
mysql=/usr/local/mysql/bin/mysql
mysql_user=root 
mysql_pass=bwh759149492
mysql_db=quant

echo "---------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------[Crontab Run ${current_date}]------------------------------------------------"
# 1.获取t-1的股票交易数据
$python -u ./get_daily_price.py 
wait 
sleep 1

# 2.将t-1的股票交易数据存入stock_daily_price_final天级别价格最终表保证无重复数据
$mysql  -u${mysql_user} -p${mysql_pass} -D${mysql_db}<./sql/get_final_daily_price.sql
wait
sleep 1

# 3.计算t-1的均线数据并存入均线数据表stock_ma_value
$mysql  -u${mysql_user} -p${mysql_pass} -D${mysql_db}<./sql/get_man_price.sql
wait
sleep 1

# 4.计算t-1的平均volume数据并存入均线数据表stock_volume_avg
$mysql  -u${mysql_user} -p${mysql_pass} -D${mysql_db}<./sql/get_volume_avg.sql
wait
sleep 1




wait
echo "---------------------------------------------------------------------------------------------------"
echo "-------------------------------------------------------[END]---------------------------------------"
exit 0