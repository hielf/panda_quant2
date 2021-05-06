'''
https://blog.csdn.net/qq_15111861/article/details/95871335
自定义转换器
'''

from .features import *
from .common import *
from .custom_fn import *
from .make_label import * 
import pandas as pd
import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin
 

def my_transformer(df, config_params, future_n):
    estimators =[]
    estimators.append(('resample', TransformerResample(config_params['resample_period'])))
    estimators.append(('custom1', GeneratorCustom(fn_custom1)))
    estimators.append(('datetime', GeneratorDateTime(feature_list= config_params["feature_datetime"])))
    estimators.append(('ta', GeneratorTa(feature_list= config_params['feature_ta'])))
    estimators.append(('describe', GeneratorDescribe(item='close', feature_list=config_params['feature_describe'])))
    estimators.append(('custom2', GeneratorCustom(fn_custom2)))
    estimators.append(('label', GeneratorLabel(set_label, create_futureitem, future_n)))
    pipline = Pipeline(estimators)

    p = pipline.fit_transform(df)

    X = p.drop(columns=['future_item1','future_item2'])
    y =  X['label']
    X = X.drop(columns=['label'])   

    X.replace([np.inf], 999999999, inplace=True)
    X.replace([-np.inf], -999999999, inplace=True)
    X=X.fillna(method='ffill')
    X=X.fillna(method='bfill')

    return X, y                            

    
class TransformerResample(BaseEstimator, TransformerMixin):
    def __init__(self, period):
        self.period = period 
 
    def fit(self, X, y=None):
        return self 
 
    def transform(self, X, y=None):
        df = resample_ohlc(X.copy(), self.period)
        df.dropna(inplace=True)

        return df


class GeneratorTa(BaseEstimator, TransformerMixin):
    def __init__(self, feature_list):
        self.feature_list = feature_list 
 
    def fit(self, X, y=None):
        return self 
 
    def transform(self, X, y=None):
        df = generate_ta(X.copy(), self.feature_list)

        return df

class GeneratorDateTime(BaseEstimator, TransformerMixin):
    def __init__(self, feature_list):
        self.feature_list = feature_list 
 
    def fit(self, X, y=None):
        return self 
 
    def transform(self, X, y=None):
        df = generate_datetime(X.copy(), 'date', self.feature_list)

        return df

class GeneratorDescribe(BaseEstimator, TransformerMixin):
    def __init__(self, item, feature_list):
        self.feature_list = feature_list 
        self.item  = item
 
    def fit(self, X, y=None):
        return self 
 
    def transform(self, X, y=None):
        df = generate_describe(X.copy(), self.item, self.feature_list)

        return df

class GeneratorCustom(BaseEstimator, TransformerMixin):
    def __init__(self , generate_custom):
        self.fn = generate_custom
 
    def fit(self, X, y=None):
        return self 
 
    def transform(self, X, y=None):

        df = self.fn(X.copy())

        return df

class GeneratorLabel(BaseEstimator, TransformerMixin):
    def __init__(self, fn_set_label, fn_create_futureitem, future_n=4):
        self.fn1 = fn_set_label
        self.fn2 = fn_create_futureitem
        self.future_n = future_n
 
    def fit(self, X, y=None):
        return self 
 
    def transform(self, X, y=None):
        df = X.copy()
        df = self.fn2(df, self.future_n)

        df['label']=df.apply(self.fn1,axis=1)

        return df