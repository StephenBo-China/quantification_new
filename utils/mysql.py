# -*- coding: utf-8 -*

import pymysql
import json 
from tools import *

class MY_SQL:
    def __init__(self):
        account_info = self.get_account()
        self.db = pymysql.connect(
            host = account_info["host"]
            ,user = account_info["user"]
            ,password = account_info["password"]
            ,db = account_info["db"]
            ,port = account_info["port"]
        )
        self.cur = self.db.cursor()

    def get_account(self):
        with open('/Users/stephenbo/JOB/PROJECT/quantification_new/params/jqdata.json', 'r') as jsonfile:
            account_dict = json.load(jsonfile)
            return account_dict["mysql_account"]
    
    def drop_table(self, table_name):
        self.cur.execute("DROP TABLE IF EXISTS %s" % (table_name))
        self.cur.connection.commit()

    def create_table(self, table_name, table_elements):
        elements_str = ""
        for element_name, element_type in table_elements.items():
            elements_str = elements_str + element_name + " " + element_type + ","
        self.cur.execute(
                """
                CREATE TABLE IF NOT EXISTS %s (%s)
                """ % (table_name, elements_str[:-1])
            )
        self.cur.connection.commit()
    
    def insert_table(self, table_name, attribute_list, elements):
        attribute_list_str = "(" + ",".join(attribute_list) + ")"
        elements_str = ""
        for element in elements:
            elements_str = elements_str + str(element) + ","
        self.cur.execute(
            """
            INSERT INTO %s%s
            VALUES
            %s
            """ % (table_name, attribute_list_str, elements_str[:-1])
        )
        self.cur.connection.commit()
    
    def select_table(self, sql_statement):
        sql = self.cur.execute(sql_statement)
        return self.cur.fetchall()

    def delete_elements(self, table_name, clause_list):
        clause_str = " AND ".join(clause_list)
        self.cur.execute(
            """
            DELETE FROM %s 
            WHERE %s
            """ % (table_name, clause_str)
        )
        self.cur.connection.commit()

    def get_insert_elements(self, data, col_list):
        rst = list()
        data_dict = change_dataframe_to_dict(data)
        for i in range(len(data)):
            insert_element = list()
            for att in col_list:
                insert_element.append(data_dict[att][i])
            insert_element = tuple(insert_element)
            rst.append(insert_element)
        return rst
    
    def close_db(self):
        self.cur.close()
        self.db.close()
