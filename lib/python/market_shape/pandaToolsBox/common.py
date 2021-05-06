
import pandas as pd
import numpy as np
import yaml
import warnings

def resample_ohlc(_df, period='5T'):

    '''reample 数据

    输入OHLC格式df, 返回resample的kbar

    Args:
        _df(pandas): ohlc+volume 必须
        period(str): pandas resample 参数相同 '5T', '1H', '1D'...

    Returns:
        pandas df
    '''

    df = _df[['date', 'open', 'high', 'low', 'close', 'volume']]
    df['date'] = pd.to_datetime(df['date'])
    df.set_index('date', inplace=True)
    df = df.resample(period).agg({'open': 'first', 
                                'high': 'max', 
                                    'low': 'min', 
                                    'close': 'last', 'volume': 'sum'})
    return df


def status(x) :
    ''' 观察数据分布
    输入pd 数据序列 X

    Args: 
        None

    Returns:
        '总数','最小值','最小值位置','25%分位数',
        '中位数','75%分位数','均值','最大值',
        '最大值位数','平均绝对偏差','方差','标准差','偏度','峰度'
    
    ''' 
    return pd.Series([x.count(),x.min(),x.idxmin(),x.quantile(.25),x.median(),
                      x.quantile(.75),x.mean(),x.max(),x.idxmax(),x.mad(),x.var(),
                      x.std(),x.skew(),x.kurt()],index=['总数','最小值','最小值位置','25%分位数',
                    '中位数','75%分位数','均值','最大值','最大值位数','平均绝对偏差','方差','标准差','偏度','峰度'])


def get_yaml_data(yaml_file):

    # 打开yaml文件
    print("***获取yaml文件数据***")
    file = open(yaml_file, 'r', encoding="utf-8")
    file_data = file.read()
    file.close()
    
    print(file_data)
    print("类型：", type(file_data))

    # 将字符串转化为字典或列表
    print("***转化yaml数据为字典或列表***")
    data = yaml.load(file_data)
    print(data)
    print("类型：", type(data))
    return data

def output_result(_df, filepath):
    import time
    random_datetime = int(time.time())
    print(_df.head())
    _df.reset_index(inplace=True)
    _df = _df[['date', 'open', 'high', 'low', 'close', 'volume', 'openinterest', 'buy_status', 'sell_status']]
    _df.set_index('date', inplace=True)

    _df.to_csv(filepath)
    print('file write to ' + filepath)
    return _df