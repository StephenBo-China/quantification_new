# -*- coding: utf-8 -*

import sys, os
import pandas as pd

def save_csv(data, file_path, header = True, sep = ",", index = None, encoding = "utf_8_sig"):
    data.to_csv(
        file_path,
        encoding = encoding,
        sep = sep,
        header = header,
        index = index
    )
