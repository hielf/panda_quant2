# -*- coding:utf-8 -*-
import pandas as pd
from sqlalchemy import create_engine
import datetime,time
import os
import psycopg2
import io
import numpy
from time import sleep

# sleep_time=5
engine = create_engine('postgresql+psycopg2://chesp:@postgres.ripple-tech.com:5432/panda_quant',echo=True,client_encoding='utf8')
conn = engine.raw_connection()
cur = conn.cursor()

directory = "/Users/hielf/Downloads/wind/data/"
for file in os.listdir(directory):
    filename = os.fsdecode(file)
    df = pd.read_csv(filepath_or_buffer=(directory+filename), encoding='gbk')

    for index, row in df.iterrows():
        Array=numpy.empty(24,dtype=object)
        Array[0]=df.values[index][0]
        Array[1]=df.values[index][1]
        Array[2]=df.values[index][2]
        Array[3]=df.values[index][3]
        Array[4]=df.values[index][4]
        Array[5]=df.values[index][5]
        Array[6]=df.values[index][6]
        Array[7]=df.values[index][7]
        Array[8]=df.values[index][8]
        Array[9]=df.values[index][9]
        Array[10]=df.values[index][10]
        Array[11]=df.values[index][11]
        Array[12]=df.values[index][12]
        Array[13]=df.values[index][13]
        Array[14]=df.values[index][14]
        Array[15]=df.values[index][15]
        Array[16]=df.values[index][16]
        Array[17]=df.values[index][17]
        Array[18]=df.values[index][18]
        Array[19]=df.values[index][19]
        Array[20]=df.values[index][20]
        Array[21]=df.values[index][21]
        Array[22]=df.values[index][22]
        Array[23]=df.values[index][23]
        sql = "INSERT INTO stock_daily_data_wind (stock_code, sec_name,trade_date,pre_close,open,high,low,close,volume,amt,chg,pct_chg,vwap,turn,mkt_cap_ashare,mkt_cap_bshare,ev,cap_stk_ashare,cap_stk_bshare,total_cap_stk,pe,pb,ps,pcf) VALUES (%s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s)"
        print(Array)
        sleep(0.01)
        cur.execute(sql, [f for f in Array])

    conn.commit()

# engine.dispose()

    # f = io.StringIO()
    # df1.to_csv(f, index=False, header=False)  # removed header
    # f.seek(0)  # move position to beginning of file before reading
    # cursor = conn.cursor()
    # cursor.copy_from(f, 'stock_daily_data_wind', columns=('stock_code', 'sec_name','trade_date','pre_close','open','high','low','close','volume','amt','chg','pct_chg','vwap','turn','mkt_cap_ashare','mkt_cap_bshare','ev','cap_stk_ashare','cap_stk_bshare','total_cap_stk','pe','pb','ps','pcf'), sep=',')
    # cursor.execute("select * from stock_daily_data_wind;")
    # a = cursor.fetchall()
    # print(a)
    # cursor.close()
    #
    # output = io.StringIO()
    # df1.to_csv(output, sep='\t', header=False, index=False)
    # output.seek(0)
    # contents = output.getvalue()
    # cur.copy_from(output, 'stock_daily_data_wind', null="") # null values become ''
    # conn.commit()
    #
    # df1.columns = ['level_0','stock_code', 'sec_name','trade_date','pre_close','open','high','low','close','volume','amt','chg','pct_chg','vwap','turn','mkt_cap_ashare','mkt_cap_bshare','ev','cap_stk_ashare','cap_stk_bshare','total_cap_stk','pe','pb','ps','pcf']
    # df1.head().to_sql(con=engine, name='stock_daily_data_wind', if_exists='append', index=False)

# -- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.
#
# -- Table Definition
# CREATE TABLE "public"."stock_daily_data_wind" (
#     "level_0" int8,
#     "index" int8,
#     "stock_code" text,
#     "sec_name" text,
#     "trade_date" date,
#     "pre_close" float8,
#     "open" float8,
#     "high" float8,
#     "low" float8,
#     "close" float8,
#     "volume" float8,
#     "amt" float8,
#     "chg" float8,
#     "pct_chg" float8,
#     "vwap" float8,
#     "turn" float8,
#     "mkt_cap_ashare" float8,
#     "mkt_cap_bshare" float8,
#     "ev" float8,
#     "cap_stk_ashare" float8,
#     "cap_stk_bshare" float8,
#     "total_cap_stk" float8,
#     "pe" float8,
#     "pb" float8,
#     "ps" float8,
#     "pcf" float8
# );
#
# -- Column Comment
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."stock_code" IS '代码';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."sec_name" IS '简称';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."trade_date" IS '日期';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."pre_close" IS '前收盘价(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."open" IS '开盘价(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."high" IS '最高价(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."low" IS '最低价(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."close" IS '收盘价(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."volume" IS '成交量(股)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."amt" IS '成交金额(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."chg" IS '涨跌(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."pct_chg" IS '涨跌幅(%)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."vwap" IS '均价(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."turn" IS '换手率(%)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."mkt_cap_ashare" IS 'A股流通市值(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."mkt_cap_bshare" IS 'B股流通市值(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."ev" IS '总市值(元)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."cap_stk_ashare" IS 'A股流通股本(股)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."cap_stk_bshare" IS 'B股流通股本(股)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."total_cap_stk" IS '总股本(股)';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."pe" IS '市盈率';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."pb" IS '市净率';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."ps" IS '市销率';
# COMMENT ON COLUMN "public"."stock_daily_data_wind"."pcf" IS '市现率';
