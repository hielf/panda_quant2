import pandas as pd
import numpy as np
from sklearn.pipeline import Pipeline
from .features import *
from .common import *
from .transformer import *
from sklearn.base import BaseEstimator, TransformerMixin
 
def fn_custom2(df):
        df['min_div_median']    = df['min_60'] / df['median_60']
        df['max_div_median']    = df['max_60'] / df['median_60']
        df['min_div_median2']    = df['min_30'] / df['median_60']
        df['max_div_median2']    = df['max_30'] / df['median_60']
        df['median_div_mean'] = df['median_60'] / df['mean_60']
        df['median_sub_close'] = df['median_60'] - df['pct_close']

        for i in [3, 7, 14, 30, 60, 140]:
                df['diff_%s_mean' % i] = df['close'].diff().rolling(i).mean()
                df['mean_%s' % i] = df['close'].rolling(i).mean()
                df['median_%s' % i] = df['close'].rolling(i).median()
                df['min_%s' % i] = df['low'].rolling(i).min()
                df['max_%s' % i] = df['high'].rolling(i).max()
                df['std_%s' % i] = df['close'].rolling(i).std()
        return df

def fn_custom1(df):

    # df = np.log2(df)
    df['pct_close'] = df.close.pct_change()
    df['pct_open'] = df.open.pct_change()
    df['pct_high'] = df.high.pct_change()
    df['pct_low'] = df.low.pct_change()
    df['pct_volume'] = df.volume.pct_change()

    df['log_return'] = df.close.apply(np.log)
    df['log_return'] = df.log_return.diff()

    return df

