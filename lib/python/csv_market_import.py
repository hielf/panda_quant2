# -*- coding:utf-8 -*-
import psycopg2
import os
import codecs
from time import sleep

directory = "/Users/hielf/Downloads/wind/data/a_stock/"
for file in sorted(os.listdir(directory)):
    filename = os.fsdecode(file)
    if filename.lower().endswith('.csv'):
        conn = psycopg2.connect("host='rm-2zelv192ymyi9680vo.pg.rds.aliyuncs.com' dbname='panda_quant' user='chesp' password='Chesp92J5' port='3432'")
        conn2 = psycopg2.connect("host='rm-2zelv192ymyi9680vo.pg.rds.aliyuncs.com' dbname='panda_quant' user='chesp' password='Chesp92J5' port='3432'")
        cur = conn.cursor()
        cur2 = conn2.cursor()
        print(directory + filename + " :started")
        with codecs.open(directory + filename,'r','gbk') as f:
            next(f)  # Skip the header row.
            try:
                cur.copy_from(f, 'wind_data', sep=',', null='None', columns=('stock_code','sec_name','trade_date','pre_close','open','high','low','close','volume','amt','chg','pct_chg','vwap','turn','mkt_cap_ashare','mkt_cap_bshare','ev','cap_stk_ashare','cap_stk_bshare','total_cap_stk','pe','pb','ps','pcf','extra'))
                conn.commit()
                conn.close()
            except:
                pass
            finally:
                cur2.copy_from(f, 'wind_data', sep=',', null='None', columns=('stock_code','sec_name','trade_date','pre_close','open','high','low','close','volume','amt','chg','pct_chg','vwap','turn','mkt_cap_ashare','mkt_cap_bshare','ev','cap_stk_ashare','cap_stk_bshare','total_cap_stk','pe','pb','ps','pcf'))
                conn2.commit()
                conn2.close()
            print(directory + filename + " :finished")
            sleep(0.5)

sql = """
    insert into stock_daily_data
    select stock_code,
    sec_name,
    trade_date,
    case
        when pre_close = '' then null
        else cast(pre_close as float)
    end,
    case
        when open = '' then null
        else cast(open as float)
    end,
    case
        when high = '' then null
        else cast(high as float)
    end,
    case
        when low = '' then null
        else cast(low as float)
    end,
    case
        when close = '' then null
        else cast(close as float)
    end,
    case
        when volume = '' then null
        else cast(volume as float)
    end,
    case
        when amt = '' then null
        else cast(amt as float)
    end,
    case
        when chg = '' then null
        else cast(chg as float)
    end,
    case
        when pct_chg = '' then null
        else cast(pct_chg as float)
    end,
    case
        when vwap = '' then null
        else cast(vwap as float)
    end,
    case
        when turn = '' then null
        else cast(turn as float)
    end,
    case
        when mkt_cap_ashare = '' then null
        else cast(mkt_cap_ashare as float)
    end,
    case
        when mkt_cap_bshare = '' then null
        else cast(mkt_cap_bshare as float)
    end,
    case
        when ev = '' then null
        else cast(ev as float)
    end,
    case
        when cap_stk_ashare = '' then null
        else cast(cap_stk_ashare as float)
    end,
    case
        when cap_stk_bshare = '' then null
        else cast(cap_stk_bshare as float)
    end,
    case
        when total_cap_stk = '' then null
        else cast(total_cap_stk as float)
    end,
    case
        when pe = '' then null
        else cast(pe as float)
    end,
    case
        when pb = '' then null
        else cast(pb as float)
    end,
    case
        when ps = '' then null
        else cast(ps as float)
    end,
    case
        when pcf = '' then null
        else cast(pcf as float)
    end
    from wind_data;
"""

conn = psycopg2.connect("host='rm-2zelv192ymyi9680vo.pg.rds.aliyuncs.com' dbname='panda_quant' user='chesp' password='Chesp92J5' port='3432'")
cur = conn.cursor()
cur.execute(sql, (10, 1000000, False, False))
conn.commit()

sql = "delete from wind_data;"

cur.execute(sql, (10, 1000000, False, False))
conn.commit()
conn.close()

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



# insert into stock_daily_data
# select stock_code,
# sec_name,
# trade_date,
# case
#     when pre_close = '' then null
#     else cast(pre_close as float)
# end,
# case
#     when open = '' then null
#     else cast(open as float)
# end,
# case
#     when high = '' then null
#     else cast(high as float)
# end,
# case
#     when low = '' then null
#     else cast(low as float)
# end,
# case
#     when close = '' then null
#     else cast(close as float)
# end,
# case
#     when volume = '' then null
#     else cast(volume as float)
# end,
# case
#     when amt = '' then null
#     else cast(amt as float)
# end,
# case
#     when chg = '' then null
#     else cast(chg as float)
# end,
# case
#     when pct_chg = '' then null
#     else cast(pct_chg as float)
# end,
# case
#     when vwap = '' then null
#     else cast(vwap as float)
# end,
# case
#     when turn = '' then null
#     else cast(turn as float)
# end,
# case
#     when mkt_cap_ashare = '' then null
#     else cast(mkt_cap_ashare as float)
# end,
# case
#     when mkt_cap_bshare = '' then null
#     else cast(mkt_cap_bshare as float)
# end,
# case
#     when ev = '' then null
#     else cast(ev as float)
# end,
# case
#     when cap_stk_ashare = '' then null
#     else cast(cap_stk_ashare as float)
# end,
# case
#     when cap_stk_bshare = '' then null
#     else cast(cap_stk_bshare as float)
# end,
# case
#     when total_cap_stk = '' then null
#     else cast(total_cap_stk as float)
# end,
# case
#     when pe = '' then null
#     else cast(pe as float)
# end,
# case
#     when pb = '' then null
#     else cast(pb as float)
# end,
# case
#     when ps = '' then null
#     else cast(ps as float)
# end,
# case
#     when pcf = '' then null
#     else cast(pcf as float)
# end
# from wind_data;
# commit;
