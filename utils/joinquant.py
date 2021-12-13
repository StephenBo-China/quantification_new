# -*- coding: utf-8 -*

import json 
from jqdatasdk import *

class joinquant:
    def __init__(self):
        account_info = self.get_account()
        auth(account_info["phone"], account_info["pass"])

    def get_account(self):
        with open('/Users/stephenbo/JOB/PROJECT/quantification_new/params/jqdata.json', 'r') as jsonfile:
            account_dict = json.load(jsonfile)
            return account_dict["account"]
    
    def get_all_stock_info(self):
        return get_all_securities(types=['stock'], date=None)