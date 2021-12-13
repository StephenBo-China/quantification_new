# -*- coding: utf-8 -*

import sys, os
import pandas as pd
import time
import datetime

def save_csv(data, file_path, header = True, sep = ",", index = None, encoding = "utf_8_sig"):
    data.to_csv(
        file_path,
        encoding = encoding,
        sep = sep,
        header = header,
        index = index
    )

def execCmd(cmd):
    r = os.popen(cmd)
    text = r.read()
    r.close()
    return text

def read_file(file_path):
    with open(file_path, "r") as f:  # 打开文件
        rst = f.read()  # 读取文件
    return rst
 
def remove_file(file_path):
    cmd = "rm -rf " + file_path 
    execCmd(cmd)

def mkdir(file_path):
    cmd = "mkdir " + file_path 
    execCmd(cmd)

def change_dataframe_to_dict(data):
    columns = data.columns 
    rst = dict()
    for col in columns:
        rst[col] = data[col].values 
    return rst 

def get_current_time():
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

def get_n_day_before(n = 1):
    return (datetime.date.today() - datetime.timedelta(days=n)).strftime("%Y-%m-%d %H:%M:%S")

