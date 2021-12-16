# -*- coding: utf-8 -*

import json 
from jqdatasdk import *
from tools import *

class joinquant:
    def __init__(self):
        account_info = self.get_account()
        auth(account_info["phone"], account_info["pass"])
        print("login account=%s success." % (account_info["phone"]))

    def get_account(self):
        with open('/Users/stephenbo/JOB/PROJECT/quantification_new/params/jqdata.json', 'r') as jsonfile:
            account_dict = json.load(jsonfile)
            return account_dict["account"]
    
    def get_all_stock_info(self):
        return get_all_securities(types=['stock'], date=None)
    
    def get_daily_price(self, stock_code, start_date, end_date):
        daily_data = get_price(
            security = stock_code
            ,start_date = start_date
            ,end_date = end_date
            ,frequency = "daily"
            ,fields = ['open','close','high','low','volume','money']
        )
        daily_data["stock_code"] = stock_code  
        save_csv(
            data = daily_data
            ,file_path = "./temp.csv"
            ,index = True
        )
        daily_data = pd.read_csv("./temp.csv")
        daily_data.columns = ['ds','open','close','high','low','volume','money','stock_code']
        return daily_data