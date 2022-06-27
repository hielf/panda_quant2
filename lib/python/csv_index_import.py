# -*- coding:utf-8 -*-
import psycopg2
import os
import codecs
from time import sleep

directory = "/Users/hielf/Downloads/wind/data/index/"
for file in sorted(os.listdir(directory)):
    filename = os.fsdecode(file)
    if filename.lower().endswith('.csv'):
        conn = psycopg2.connect("host='postgres.ripple-tech.com' dbname='panda_quant' user='chesp' password='' port='5432'")
        conn2 = psycopg2.connect("host='postgres.ripple-tech.com' dbname='panda_quant' user='chesp' password='' port='5432'")
        cur = conn.cursor()
        cur2 = conn2.cursor()
        print(directory + filename + " :started")
        with codecs.open(directory + filename,'r','gbk') as f:
            next(f)  # Skip the header row.
            try:
                cur.copy_from(f, 'wind_index_data', sep=',', null='None', columns=('stock_code','sec_name','trade_date','pre_close','open','high','low','close','volume','amt','chg','pct_chg','extra'))
                conn.commit()
                conn.close()
            except:
                pass
            finally:
                cur2.copy_from(f, 'wind_index_data', sep=',', null='None', columns=('stock_code','sec_name','trade_date','pre_close','open','high','low','close','volume','amt','chg','pct_chg'))
                conn2.commit()
                conn2.close()
            print(directory + filename + " :finished")
            sleep(0.5)

sql = """
    insert into index_daily_data
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
    end
    from wind_index_data;
"""

conn = psycopg2.connect("host='postgres.ripple-tech.com' dbname='panda_quant' user='chesp' password='' port='5432'")
cur = conn.cursor()
cur.execute(sql, (10, 1000000, False, False))
conn.commit()

sql = "delete from wind_index_data;"

cur.execute(sql, (10, 1000000, False, False))
conn.commit()
conn.close()

# -- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.
#
# -- Table Definition
# CREATE TABLE "public"."index_daily_data" (
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
#     "pct_chg" float8
# );
#
# -- Column Comment
# COMMENT ON COLUMN "public"."index_daily_data"."stock_code" IS '代码';
# COMMENT ON COLUMN "public"."index_daily_data"."sec_name" IS '简称';
# COMMENT ON COLUMN "public"."index_daily_data"."trade_date" IS '日期';
# COMMENT ON COLUMN "public"."index_daily_data"."pre_close" IS '前收盘价(元)';
# COMMENT ON COLUMN "public"."index_daily_data"."open" IS '开盘价(元)';
# COMMENT ON COLUMN "public"."index_daily_data"."high" IS '最高价(元)';
# COMMENT ON COLUMN "public"."index_daily_data"."low" IS '最低价(元)';
# COMMENT ON COLUMN "public"."index_daily_data"."close" IS '收盘价(元)';
# COMMENT ON COLUMN "public"."index_daily_data"."volume" IS '成交量(股)';
# COMMENT ON COLUMN "public"."index_daily_data"."amt" IS '成交金额(元)';
# COMMENT ON COLUMN "public"."index_daily_data"."chg" IS '涨跌(元)';
# COMMENT ON COLUMN "public"."index_daily_data"."pct_chg" IS '涨跌幅(%)';



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
