# -*- coding: utf-8 -*

import sys, os
import pandas as pd
import params
from jqdatasdk import *

def login_jqdata():
    auth(params.JQ_PARAMS["JQ_ACCOUNT"]["account"],params.JQ_PARAMS["JQ_ACCOUNT"]["pass"])

def save_csv(data, file_path, header = True, sep = ",", index = None, encoding = "utf_8_sig"):
    data.to_csv(
        file_path,
        encoding = encoding,
        sep = sep,
        header = header,
        index = index
    )
