# -*- coding: utf-8 -*

PROJECT_PATH = ""
import sys, os
sys.path.append(PROJECT_PATH + "./utils")
import mysql as mq 
from tools import *
import time
from joinquant import *
import pandas as pd

mysql = mq.MY_SQL()
account_num = 6
jqdata = joinquant("account1")

def create_stock_daily_price_table():
    return mysql.create_table(
        table_name = "stock_daily_price_tmp"#"stock_daily_price"
        ,table_elements = {
                "stock_code":       "VARCHAR(1000)"
                ,"ds":              "VARCHAR(1000)"
                ,"open":            "FLOAT"
                ,"close":           "FLOAT"
                ,"high":            "FLOAT"
                ,"low":             "FLOAT"
                ,"volume":          "FLOAT"
                ,"money":           "FLOAT"
            }
    )

def get_stock_info_dict(stock_info):
    stock_start_date_dict = dict()
    stock_end_date_dict = dict()
    stock_code_list = list()
    for element in stock_info:
        stock_code = element[1]
        start_date = element[2]
        end_date = element[3]
        stock_start_date_dict[stock_code] = start_date 
        stock_end_date_dict[stock_code] = end_date 
        stock_code_list.append(stock_code)
    return {
        "stock_start_date_dict": stock_start_date_dict
        ,"stock_end_date_dict": stock_end_date_dict
        ,"stock_code_list": stock_code_list
    }

def get_stock_info():
    select_sql = open("./sql/get_stock_info.sql").read()
    stock_info = mysql.select_table(select_sql)
    return stock_info

def get_stock_daily_price(stock_info_dict):
    stock_code_list = stock_info_dict["stock_code_list"]
    stock_start_date_dict = stock_info_dict["stock_start_date_dict"]
    stock_end_date_dict = stock_info_dict["stock_end_date_dict"]
    current_time = get_current_time()
    current_time = string_date_convert(
        current_time
        ,input_format = "%Y-%m-%d %H:%M:%S"
        ,output_format = "%Y-%m-%d"
    )
    current_time = string_date_convert(
        current_time
        ,input_format = "%Y-%m-%d"
        ,output_format = "%Y-%m-%d %H:%M:%S"
    )
    for stock_code in stock_code_list:
        start_date = stock_start_date_dict[stock_code]
        if start_date > "2021-01-01":
            start_date = get_n_day_after(
                n = 1
                ,current_date = string2datetime(start_date)
            )
        else:
            start_date = string_date_convert(start_date)
        end_date = current_time
        print("Processing stock_code=%s;start_date=%s;end_date=%s ..." % (stock_code, start_date, end_date))
        stock_daily_price = jqdata.get_daily_price(
            stock_code
            ,start_date = start_date
            ,end_date = end_date
        )
        if len(stock_daily_price) > 0:
            stock_daily_price['open'] = stock_daily_price['open'].fillna(-1.)
            stock_daily_price['close'] = stock_daily_price['close'].fillna(-1.)
            stock_daily_price['high'] = stock_daily_price['high'].fillna(-1.)
            stock_daily_price['low'] = stock_daily_price['low'].fillna(-1.)
            stock_daily_price['volume'] = stock_daily_price['volume'].fillna(-1.)
            stock_daily_price['money'] = stock_daily_price['money'].fillna(-1.)
            stock_daily_price_elements = mysql.get_insert_elements(stock_daily_price, stock_daily_price.columns)
            mysql.insert_table(
                table_name = "stock_daily_price_tmp"
                ,attribute_list = stock_daily_price.columns
                ,elements = stock_daily_price_elements
            )
            time.sleep(0.05)

def main():
    stock_info = get_stock_info()
    create_stock_daily_price_table()
    stock_info_dict = get_stock_info_dict(stock_info)
    get_stock_daily_price(stock_info_dict)

if __name__ == '__main__':
    for i in range(2, 7):
        try:
            main()
        except:
            jqdata = joinquant("account%d" % (i))
            continue 
