# -*- coding: utf-8 -*

import pymysql

class MY_SQL:
    def __init__(self):
        self.db = pymysql.connect(
            host = "localhost"
            ,user = 'root'
            ,password = "bwh759149492"
            ,db = 'quant'
            ,port = 3306
        )
        self.cur = self.db.cursor()
    
    def drop_table(self, table_name):
        self.cur.execute("DROP TABLE IF EXISTS %s" % (table_name))
        self.cur.connection.commit()

    def create_table(self, table_name, table_elements):
        elements_str = ""
        for element_name, element_type in table_elements.items():
            elements_str = elements_str + element_name + " " + element_type + ","
        self.cur.execute(
                """
                CREATE TABLE %s (%s)
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
    
    def close_db(self):
        self.cur.close()
        self.db.close()