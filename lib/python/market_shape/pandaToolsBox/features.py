import talib as ta
import pandas as pd
import logging
logging.basicConfig(level=logging.INFO)




def generate_ta(_df, features=[]):
    '''生成ta特征

    输入OHLC格式df, 和特征列表

    Args:
        _df(pandas): ohlc+volume 必须
        features(list): 格式特征_特征参数1_参数2, ema_5, STOCHRSI_8_14_5
                macd:
                    macd = 12 天 EMA - 26 天 EMA
                    signal = 9 天 MACD的EMA
                    hist = MACD - MACD signal
    Returns:
        pandas df
    '''

    _high = _df['high']
    _low = _df['low']
    _close = _df['close']
    _volume = _df['volume']
    # 分析特征
    for feature in features:
        flist =  feature.split('_')
        if len(flist) > 0:
            p1 = None
            p2 = None
            p3 = None
        else:
            return 400
        if len(flist) > 1:
            p1 = int(flist[1])
        if len(flist) > 2:
            p2 = int(flist[2])
        if len(flist) > 3:
            p3 = int(flist[3])

        if flist[0] == 'ema':
            if p1 == None:
                p1 = 5
            _df[feature] = ta.EMA(_close, timeperiod=p1)

        if flist[0] == 'sma':
            if p1 == None:
                p1 = 5
            _df[feature] = ta.SMA(_close, timeperiod=p1)
        
        if flist[0] == 'rsi':
            if p1 == None:
                p1 = 14
            _df[feature] = ta.RSI(_close, timeperiod=p1)
        
        if flist[0] == 'atr':
            if p1 == None:
                p1 = 14
            _df[feature] = ta.ATR(_high, _low, _close, timeperiod=p1)

        if flist[0] == 'macd':
            if p1 == None:
                p1 = 12
                p2 = 26
                p3 = 9
            _df[feature + '_macd'], _df[feature + '_macdsignal'], _df[feature + '_macdhist'] = ta.MACD(_close, 
                                fastperiod=p1, 
                                slowperiod=p2, 
                                signalperiod=p3
                                )

        if flist[0] == 'adosc':
            if p1 == None:
                p1 = 3
                p2 = 10
            _df[feature] = ta.ADOSC(_high, _low, _close, _volume, p1, p2)

        if flist[0] == 'bbands':
            if p1 == None:
                p1 = 5
                p2 = 2
                p3 = 2
            if p2 == None:
                p2 = 2
                p3 = 2
            if p3 == None:
                p3 = 2
            _df[feature +"_upper"], _df[feature + "_middle"], _df[feature + "_lower"] = ta.BBANDS(_close, timeperiod=p1, nbdevup=p2, nbdevdn=p3)

        if flist[0] == 'sar':
            _df[feature]=ta.SAR(_high, _low, acceleration=0, maximum=0)
        
        if flist[0] == 'aroon':
            if p1 == None:
                p1 = 14
            _df[feature + "_down"],_df[feature + "_up"] = ta.AROON(_high, _low, timeperiod=p1)

        if flist[0] == 'ad':
            _df[feature]= ta.AD(_high, _low, _close, _volume)
        
        if flist[0] == 'cci':
            if p1 == None:
                p1 = 14
            _df[feature] = ta.CCI(_high, _low, _close, timeperiod=p1)
        
        if flist[0] == 'beta':
            if p1 == None:
                p1 = 5
            _df[feature] = ta.BETA(_high, _low, timeperiod=p1)

        if flist[0] == 'mfi':
            if p1 == None:
                p1 = 14
            _df[feature] = ta.MFI(_high, _low, _close, _volume, timeperiod=p1)        



    return _df

def generate_describe(_df, item = 'close', features=[]):
    '''生成pandas describe 特征

    输入OHLC格式df, 和特征列表:(min, max, std, q25, q75 参考 pandas.describe)

    Args:
        _df(pandas): ohlc+volume 必须
        features(list): 格式特征_时间参数, min_60
                macd:
                    macd = 12 天 EMA - 26 天 EMA
                    signal = 9 天 MACD的EMA
                    hist = MACD - MACD signal
    Returns:
        pandas df
    '''

    for feature in features:
        flist =  feature.split('_')
        if len(flist) > 1:
            p1 = int(flist[1])
        if len(flist) > 2:
            p2 = int(flist[2])
        if len(flist) > 3:
            p3 = int(flist[3])

        if flist[0] == 'std':
            _df[feature] = _df[item].rolling(p1).std()
        
        if flist[0] == 'min':
            _df[feature] = _df[item].rolling(p1).min()
        
        if flist[0] == 'max':
            _df[feature] = _df[item].rolling(p1).max()
        
        if flist[0] == 'median':
            _df[feature] = _df[item].rolling(p1).median()
        
        if flist[0] == 'mean':
            _df[feature] = _df[item].rolling(p1).mean()
        
        if flist[0] == 'q25':
            _df[feature] = _df[item].rolling(p1).quantile(.25)

        if flist[0] == 'q75':
            _df[feature] = _df[item].rolling(p1).quantile(.75)
        
        if flist[0] == 'skew':
            _df[feature] = _df[item].rolling(p1).skew()
        
        if flist[0] == 'kurt':
            _df[feature] = _df[item].rolling(p1).kurt()

    return _df

def generate_datetime(_df, cname, d_lst=[]):
    '''生成时间特征

    输入OHLC格式df

    Args:
        _df(pandas): ohlc+volume 必须
        cname: 时间列, 必须
        d_list(list): minute, hour, day_of_week, quarter, month, day_of_year, day_of_month, week_of_year
    Returns:
        pandas df
    '''

    logging.info(list(_df.columns))
    _df.reset_index(inplace=True)

    for item in d_lst:
        if item == 'minute':
            _df['minute'] = _df[cname].dt.minute
        if item == 'hour':
            _df['hour'] = _df[cname].dt.hour
        if item == 'day_of_week':
            _df['day_of_week'] = _df[cname].dt.dayofweek
        if item == 'quarter':
            _df['quarter'] = _df[cname].dt.quarter
        if item == 'month':
            _df['month'] = _df[cname].dt.month
        if item == 'day_of_year':
            _df['day_of_year'] = _df[cname].dt.dayofyear
        if item == 'day_of_month':
            _df['day_of_month'] = _df[cname].dt.day
        if item == 'week_of_year':
            _df['week_of_year'] = _df[cname].dt.weekofyear

    _df.set_index('date', inplace=True)

    return _df
