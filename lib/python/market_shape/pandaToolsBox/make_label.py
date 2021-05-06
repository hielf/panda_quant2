import pandas as pd
import numpy as np

def set_label(row):
    if row['future_item1'] > row['future_item2']  and row['future_item2'] > 0:
        return 1
    else:
        return 0


def create_futureitem(df, n= 4):
    df['future_item1'] = df['log_return'].rolling(n).sum() 
    df['future_item2'] = df['log_return'].rolling(n).max() 
    df['future_item1'] = df['future_item1'].shift(-1*n)
    df['future_item2'] = df['future_item2'].shift(-1*n)

    return df