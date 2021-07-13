# from jqdatasdk import *
from io import StringIO
import pandas as pd
import numpy as np
import sys

import requests,json
url="https://dataapi.joinquant.com/apis"

#获取调用凭证
def get_token(mob, pwd):
    body={
        "method": "get_token",
        "mob": mob,  #mob是申请JQData时所填写的手机号
        "pwd": pwd,  #Password为聚宽官网登录密码，新申请用户默认为手机号后6位
    }
    return requests.post(url, data = json.dumps(body)).text

def get_data(response):   # 数据处理函数,处理csv字符串函数
    '''格式化数据为DataFrame'''
    return pd.read_csv(StringIO(response.text))

def http_get_bars(token,code,count,unit,end_date=None,fq_ref_date=None):
    body ={
    "method": "get_bars",
    "token": token,
    "code": code,
    "count": count,
    "unit": unit,
    "end_date": end_date,
    "fq_ref_date": fq_ref_date,
    "include_now": True
    }
#     print(requests.post(url, data = json.dumps(body)).text)
    return  get_data(requests.post(url, data = json.dumps(body))).set_index('date')

def process_data(data):
    df = data.copy()
    if 'id' in df:
        df = df.drop('id', 1)

    if 'amount' in df:
        pass
    else:
        df['amount'] = df['volume']

    df.insert(0, 'id', np.arange(len(df)))
    close_px = df['close']
    # 收盘价差
    df['close_diff'] = df['close'].diff()
    df['mavg_close'] = close_px.rolling(window=5).mean()
    df['mavg_close_diff'] = df['mavg_close'].diff()
    # 下跌状态
    df['close_desceding_status'] = df.close_diff <= 0
    # 上涨状态
    df['close_rising_status'] = df.close_diff > 0
    # 交易量价差
    df['amount_diff'] = df['amount'].diff()
    # 交易量下跌状态
    df['amount_desceding_status'] = df.amount_diff <= 0
    # 交易量上涨状态
    df['amount_rising_status'] = df.amount_diff > 0
    # 连续下跌计数
    li = df['close_desceding_status'].to_numpy()
    max_time = 0   # 已知最大连续出现次数初始为0
    cur_time = 1   # 记录当前元素是第几次连续出现
    arr = []
    pre_element = None   # 记录上一个元素是什么
    for i in li:
        if i == pre_element and i == True:   # 如果当前元素和上一个元素相同,连续出现次数+1,并更新最大值
            cur_time += 1
            max_time = max((cur_time, max_time))
        else:   # 不同则刷新计数器
            pre_element = i
            cur_time = 1
    #     print(i, cur_time, max_time)
        arr.append(cur_time)

    df['close_desceding_count'] = np.array(arr)
    # 连续上涨计数
    li = df['close_rising_status'].to_numpy()
    max_time = 0   # 已知最大连续出现次数初始为0
    cur_time = 1   # 记录当前元素是第几次连续出现
    arr = []
    pre_element = None   # 记录上一个元素是什么
    for i in li:
        if i == pre_element and i == True:   # 如果当前元素和上一个元素相同,连续出现次数+1,并更新最大值
            cur_time += 1
            max_time = max((cur_time, max_time))
        else:   # 不同则刷新计数器
            pre_element = i
            cur_time = 1
    #     print(i, cur_time, max_time)
        arr.append(cur_time)

    df['close_rising_count'] = np.array(arr)
    # 交易量连续下跌计数
    li = df['amount_desceding_status'].to_numpy()
    max_time = 0   # 已知最大连续出现次数初始为0
    cur_time = 1   # 记录当前元素是第几次连续出现
    arr = []
    pre_element = None   # 记录上一个元素是什么
    for i in li:
        if i == pre_element and i == True:   # 如果当前元素和上一个元素相同,连续出现次数+1,并更新最大值
            cur_time += 1
            max_time = max((cur_time, max_time))
        else:   # 不同则刷新计数器
            pre_element = i
            cur_time = 1
    #     print(i, cur_time, max_time)
        arr.append(cur_time)

    df['amount_desceding_count'] = np.array(arr)
    # 交易量连续上涨计数
    li = df['amount_rising_status'].to_numpy()
    max_time = 0   # 已知最大连续出现次数初始为0
    cur_time = 1   # 记录当前元素是第几次连续出现
    arr = []
    pre_element = None   # 记录上一个元素是什么
    for i in li:
        if i == pre_element and i == True:   # 如果当前元素和上一个元素相同,连续出现次数+1,并更新最大值
            cur_time += 1
            max_time = max((cur_time, max_time))
        else:   # 不同则刷新计数器
            pre_element = i
            cur_time = 1
    #     print(i, cur_time, max_time)
        arr.append(cur_time)

    df['amount_rising_count'] = np.array(arr)

    # 上一个最高价
    arr = []
    for (idx, row) in df.iterrows():
        last_highest_close = df.iloc[row.id - row.close_desceding_count].close
        arr.append(last_highest_close)

    df['last_highest_close'] = np.array(arr)
    # 上一个最低价
    arr = []
    for (idx, row) in df.iterrows():
        last_lowest_close = df.iloc[row.id - row.close_rising_count].close
        arr.append(last_lowest_close)

    df['last_lowest_close'] = np.array(arr)
    # 连续累计跌幅
    df['close_desceding_rate'] = (df.close - df.last_highest_close) / df.last_highest_close
    # 连续累计涨幅
    df['close_rising_rate'] = (df.close - df.last_lowest_close) / df.last_lowest_close
    # 当前bar涨跌幅
    df['current_change_rate'] = df.close_diff / df.open
    return df
