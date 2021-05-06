from WindPy import w
from io import StringIO
import pandas as pd
import numpy as np
import sys
w.start() # 默认命令超时时间为120秒，如需设置超时时间可以加入waitTime参数，例如waitTime=60,即设置命令超时时间为60秒

w.isconnected() # 判断WindPy是否已经登录成功
from datetime import *
count = 0
for asset in assetList:
    print (asset)
    count = count + 1
    code=asset;
    fields="open,high,low,close,volume,amt";
    error,data=w.wsi(code, fields, "2020-05-01 09:30:00", datetime.today(), "", Fill="Previous", usedf=True)
    data.to_csv('./data/' + asset + '_1min.csv', sep='\t', encoding='utf-8')
    if count > 10:
        break
        
count = 0
for asset in assetList:
    print (asset)
    count = count + 1
    code=asset;
    fields="open,high,low,close,volume,amt";
    error,data=w.wsi(code, fields, "2018-01-01 09:30:00", datetime.today(), "",BarSize=5, Fill="Previous", usedf=True)
    data.to_csv('./data/' + asset + '_5min.csv', sep='\t', encoding='utf-8')
    if count > 10:
        break
