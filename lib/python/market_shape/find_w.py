# from jqdatasdk import *
from io import StringIO
import pandas as pd
import numpy as np
import sys
from jq_market_data import get_token, http_get_bars, process_data
import math
import os
import glob
import json
import datetime
import dateutil.parser

# ["110031.SH","110033.SH","110034.SH","110038.SH","110041.SH", "110042.SH",
#  "110043.SH","110044.SH","110045.SH", "110047.SH","110048.SH"]

## 参数 1min
# stock_code = '110044.SH' #代码
# duration = '1min' #周期 (1min  or  5min)
# close_desceding_x = 2 #连续收盘下跌次数
# close_desceding_rate_x = -0.005 #连续收盘下跌幅度
# amount_desceding_x = 0 #连续交易量下跌次数
# amount_rising_count_bp = 3 #突破连续成交量放大次数
# close_rising_count_s = 2 #买入连续冲高次数
# close_rising_rate_s = -0.001 #冲高回落跌幅

## 参数 5min
# stock_code = '110034.SH' #代码
# duration = '5min' #周期 (1min  or  5min)
# close_desceding_x = 4 #连续收盘下跌次数
# close_desceding_rate_x = -0.02 #连续收盘下跌幅度
# amount_desceding_x = 0 #连续交易量下跌次数
# amount_rising_count_bp = -1 #突破连续成交量放大次数
# close_rising_count_s = 3 #买入连续冲高次数
# close_rising_rate_s = -0.005 #冲高回落跌幅

# 下探筑底
# 连续收盘下跌 n 同时连续交易量下跌 p 或 一段周期内连续下跌 n 且累计跌幅超过 m
def find_X(n, m, p, df):
    id = 0
    bottom_price = 0
    for (i, r) in df.iterrows():
        id = int(r.id)
        if (r.close_desceding_count >= n and r.amount_desceding_count >= p and r.close_desceding_rate < m):
            # print ("close_desceding_count:", r.close_desceding_count, "amount_desceding_count:", r.amount_desceding_count, "close_desceding_count:", r.close_desceding_count, "close_desceding_rate:", r.close_desceding_rate)
            bottom_price = r.close
            X = df.loc[df['id'] == (r.id + 1)]
            if (df.id == (r.id + 1)).any():
                if (X.close_desceding_status.values[0] == False):
                    # print (i, r.id, bottom_price, r.close_desceding_count, r.close_desceding_rate)
                    break
    return id, bottom_price

# 向上回调
def find_Y(x_id, df):
    id = 0
    resistant_price = 0
    mask = df['id'] > x_id
    for i, r in df.loc[mask].iterrows():
        id = int(r.id)
        resistant_price = r.close
        Y = df.loc[df['id'] == (r.id + 1)]
        if (df.id == (r.id + 1)).any():
            if (Y.close_rising_status.values[0] == False):
    #             print (Y.id, resistant_price)
                break
    return id, resistant_price

# 再次向下调整
def find_Z(y_id, resistant_price, bottom_price, df):
    mask = df['id'] > y_id
    flag = True
    second_bottom_price = 0
    id = 0
    count = 1
    for i, r in df.loc[mask].iterrows():
        current_bottom_price = r.close
        Z = df.loc[df['id'] == (r.id - 1)]
        if (df.id == (r.id - 1)).any():
            second_bottom_price = float(Z.close)
#             print (i, int(Z.id), second_bottom_price, resistant_price)
            if count >= 3:
                flag = False
                id = int(r.id)
                break
            if current_bottom_price <= bottom_price:
                flag = False
                id = int(r.id)
                break
            if ((r.close_rising_status == True) & (second_bottom_price < resistant_price)):
                id = int(Z.id)
                break
        count = count + 1
    return id, flag, second_bottom_price

# 向上回拉，创新高
# 连续成交量放大 q
def find_buy_point(run_flag, z_id, resistant_price, df, q):
    mask = df['id'] > z_id
    flag = False
    buy_price = 0
    id = z_id
    if run_flag == False:
        return id, flag, buy_price
    for i, r in df.loc[mask].iterrows():
        buy_price = r.high
        if r.close_rising_status == False:
            id = int(r.id)
            break
        if (buy_price > resistant_price and r.amount_rising_count > q):
            # print ("amount_rising_count:", r.amount_rising_count)
            flag = True
            id = int(r.id)
            break
    return id, flag, buy_price

# 冲高回落
# 连续上涨 c  or  出现回落
def find_S(c, d, b_p_id, df):
    mask = df['id'] > b_p_id
    id = b_p_id
    sell_price = 0
    for i, r in df.loc[mask].iterrows():
        id = int(r.id)
        if (r.close_desceding_count >= 2 or r.close_rising_count >= c or r.close_desceding_rate <= d):
            sell_price = r.close
            break
    return id, sell_price

def plottingfunction(mask_df, points, ax=None, show=True):
    import matplotlib as mpl
    import matplotlib.pyplot as plt
    # from datetime import datetime

    plt.style.use('ggplot')

    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False

    # n = 100
    # idx = pd.date_range(start=datetime(2016, 1, 1, 10), freq='10Min', periods=n)
    data = mask_df
    close_px = mask_df['close']
    volume_px = mask_df['amount']

    fig, ax = plt.subplots(nrows=2, sharex=True, figsize=(15,10))

    ax[0].plot(data.index, data.close, color='red')
    ax[1].bar(data.index, data.amount, width=1/(3*len(data.index)), color='red')

    # xfmt = mpl.dates.DateFormatter('%H:%M')
    # ax[1].xaxis.set_major_locator(mpl.dates.HourLocator(interval=3))
    # ax[1].xaxis.set_major_formatter(xfmt)
    #
    # ax[1].xaxis.set_minor_locator(mpl.dates.HourLocator(interval=1))
    # ax[1].xaxis.set_minor_formatter(xfmt)

    ax[1].get_xaxis().set_tick_params(which='major', pad=25)

    for point in points:
        row = data.loc[data['id'] == point[0]]
        # print (row.index, row.id, row.close)
        text = point[2] + ' ' + str(point[1])
        x = row.index
        y = row.close
        ax[0].annotate(s=text,xy=(x,y),xytext=(x,y),weight='bold',color='black',\
                 arrowprops=dict(arrowstyle='-|>',connectionstyle='arc3',color='red'),\
                bbox=dict(boxstyle='round,pad=0.5', fc='yellow', ec='k',lw=1 ,alpha=0.4))

    fig.autofmt_xdate()
    return fig, ax

if __name__ == '__main__':
    stock_code = sys.argv[1] #代码
    duration = sys.argv[2] #周期 (1min  or  5min)
    close_desceding_x = sys.argv[3] #连续收盘下跌次数
    close_desceding_rate_x = sys.argv[4] #连续收盘下跌幅度
    amount_desceding_x = sys.argv[5] #连续交易量下跌次数
    amount_rising_count_bp = sys.argv[6] #突破连续成交量放大次数
    close_rising_count_s = sys.argv[7] #买入连续冲高次数
    close_rising_rate_s = sys.argv[8] #冲高回落跌幅

    data = pd.read_csv('./data/' + stock_code + '_' + duration +'.csv', sep='\t', encoding='utf-8', index_col=0)
    df = process_data(data)
    # print (df)
    df.to_csv('tmp.csv', sep='\t', encoding='utf-8')

    n = int(close_desceding_x)
    m = float(close_desceding_rate_x)
    p = int(amount_desceding_x)
    q = int(amount_rising_count_bp)
    c = int(close_rising_count_s)
    d = float(close_rising_rate_s)
    market_df = df.copy()
    id = 1
    j = []

    while market_df.shape[0] > 1:
        points = []
        current_df = market_df.drop(market_df[market_df.id < id].index)

        x_id, bottom_price = find_X(n, m, p, current_df)
        id = x_id
        if bottom_price == 0 and id == 0:
            break

        y_id, r_p = find_Y(x_id, current_df)
        id = y_id
        if r_p == 0 and id == 0:
            break

        z_id, z_flag, s_b_p = find_Z(y_id, r_p, bottom_price, current_df)
        id = z_id
        if s_b_p == 0 and id == 0:
            break

        b_p_id, flag, b_p = find_buy_point(z_flag, z_id, r_p, current_df, q)
        id = b_p_id

        net = 0
        if flag == True:
            print('hit bottom', x_id, bottom_price)
            points.append([x_id, bottom_price, "最低点 X"])
            print('hit resistant', y_id, r_p)
            points.append([y_id, r_p, "阻力位 Y"])
            print('hit second bottom', z_id, z_flag, s_b_p)
            points.append([z_id, s_b_p, "支撑位 Z"])
            print('result: ', b_p_id, flag, b_p)
            points.append([b_p_id, b_p, "突破买入 BUY"])
            print ('find w')
            s_p_id, s_p = find_S(c, d, b_p_id, df)
            print('sell: ', s_p_id, s_p)
            points.append([s_p_id, s_p, "卖出 SELL"])
            id = s_p_id

            if s_p_id > b_p_id:
                mask = ((current_df['id'] >= x_id - n) & (current_df['id'] <= s_p_id))
                mask_df = current_df.loc[mask]
                profit_ratio = round((s_p - b_p) / b_p, 4)
                print ('profit_ratio', profit_ratio)
                begin_time = mask_df.index.values[0]
                end_time = mask_df.index.values[-1]
                j.append({'stock_code': stock_code, 'duration': duration, 'params': {'close_desceding_x': close_desceding_rate_x, 'amount_desceding_x': amount_desceding_x, 'amount_rising_count_bp': amount_rising_count_bp, 'close_rising_count_s': close_rising_count_s, 'close_rising_rate_s': close_rising_rate_s}, 'results': points, 'profit_ratio': profit_ratio, 'begin_time': begin_time, 'end_time': end_time})

    with open('./result.json', 'w') as f:
        print (j)
        json.dump(j, f)
