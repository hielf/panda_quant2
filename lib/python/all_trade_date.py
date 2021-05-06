# -*- coding:utf-8 -*-
import pandas as pd
from WindPy import *
from sqlalchemy import create_engine
import datetime,time
import os
import psycopg2

w.start()
engine = create_engine('postgresql+psycopg2://chesp:Chesp92J5@rm-2zelv192ymyi9680vo.pg.rds.aliyuncs.com:3432/panda_quant',echo=True,client_encoding='utf8')

dates = w.tdays("1990-01-01")

index_data = pd.DataFrame()
index_data['trade_date']=dates.Times
#print(index_data)

index_data.to_sql('trade_date',engine,if_exists='append');


# -- Table Definition
# CREATE TABLE "public"."trade_date" (
#     "trade_date" date
# );
