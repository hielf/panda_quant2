
#%%
#0 初始化环境
#file:subsubmodule
import gc # 垃圾回收
import os,sys
#设置当前工作目录，放再import其他路径模块之前
os.chdir(sys.path[0])

os.system('export DISPLAY=:0.0') # 解决vscode 不显示图片问题, 本质是没有读到DISPLAY环境变量
import logging
logging.basicConfig(level=logging.INFO)

#%%
# 1 import 导入相关库
import numpy as np
import talib as ta
import seaborn as sns
import matplotlib.pyplot as plt #可视化模块
import warnings
import sklearn
import sklearn.metrics as me
from sklearn.ensemble import RandomForestClassifier as RM#随机森林分类模型
from pandaToolsBox.features import *
from pandaToolsBox.transformer import * 
from pandaToolsBox.common import *
from pandaToolsBox.make_label import *
from pandaToolsBox.custom_fn import *
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.model_selection import cross_val_score, GridSearchCV
from sklearn.metrics import mean_squared_error

from xgboost.sklearn import XGBClassifier 
import lightgbm as lgb

import pandas as pd
import numpy as np 

import yaml
from sklearn.feature_selection import RFECV
import joblib

# %%
# 2 加载数据
current_path = os.path.abspath(".")
yaml_path = os.path.join(current_path, "513500.yml")
config_params = get_yaml_data(yaml_path)

df1 = pd.read_csv(config_params['source'],  skiprows=0, header=0, sep=',')
logging.info('df1 loading shape:', df1.shape)


#%%
# 3 设置目标函数 X, Y
# TODO: 自动创建合适目标, 搜索合适的未来范围
# 加载make label

# 预测未来第几个bar的范围
future_n = 4

X, y = my_transformer(df1, config_params, future_n)
print(X.shape, y.shape)

# 去掉因为指标生成的nan 空列
X= X.iloc[144:int(len(X))- future_n]
y= y.iloc[144:int(len(y))- future_n]
# 去掉ohlc
X = X.iloc[:, 5:]

print(X.shape, y.shape)

# 查看分布, TODO: 分析y , 如果y不合理, 重新生成

print('总数:', y.sum()/y.count())
plt.hist(y, bins=2, normed=0, facecolor="blue", edgecolor="black", alpha=0.7)

plt.show()


#%%
# 5 划分数据集
# X.dropna(inplace=True)
#修改支持最新sklearn https://github.com/dreamlx/TSCV.git
from tscv import GapWalkForward
# gap = 1week, test = 1month
cv = GapWalkForward(n_splits=12, gap_size=4*5, test_size=4*5*4)

for item in config_params['feature_datetime']:
    if item in X.columns:
        X[item] = X[item].astype('category')

#%%
#6 创建自定义评估函数
my_scorer = me.make_scorer(me.fbeta_score, beta=2) 

gbm=lgb.LGBMClassifier(n_estimators=100, max_depth=-1, subsample=0.8, colsample_bytree=0.8,is_unbalance=True, boosting_type='dart', random_state=2018)  #lgb
# import time
# t0 = time.time()
# gbm.fit(X,y)
# t1 = time.time()
# print('gpu version elapse time: {}'.format(t1-t0))

rfecv = RFECV(estimator=gbm, min_features_to_select=6, step=1, cv=cv, scoring=my_scorer)

rfecv.fit(X, y)
print('Selected features: %s' % list(X.columns[rfecv.support_]))

print("Optimal number of features : %d" % rfecv.n_features_)
print("Ranking of features : %s" % rfecv.ranking_)

# Plot number of features VS. cross-validation scores
plt.figure()
plt.xlabel("Number of features selected")
plt.ylabel("Cross validation score (nb of correct classifications)")
plt.plot(range(1, len(rfecv.grid_scores_) + 1), rfecv.grid_scores_)
plt.show()

#%%
# 7 查看结果
rfecv.grid_scores_.mean()

filter_columns  =list(X.columns[rfecv.support_])

filter_columns 

#%%
# 8 不同评估情况下的计分
def muti_score(df_X, df_y, model, cv , scores = ['all']):
    warnings.filterwarnings('ignore')
    if scores[0] == 'all':
        scores = ['accuracy' , 'precision', 'recall', 'f1_score', 'auc', 'log_loss']
    
    scores_result = {}
    for score in scores:
        if score == 'accuracy':
            accuracy = cross_val_score(model, df_X, df_y, scoring='accuracy', cv=cv)
            print("准确率:",accuracy.mean())
            scores_result['accuracy'] = accuracy
        if score == 'precision':
            precision = cross_val_score(model, df_X, df_y, scoring='precision', cv=cv)
            print("精确率:",precision.mean())
            scores_result['precision'] = precision
        if score == 'recall':
            recall = cross_val_score(model, df_X, df_y, scoring='recall', cv=cv)
            print("召回率:",recall.mean())
            scores_result['recall'] = recall
        if score == 'f1_score':
            f1_score = cross_val_score(model, df_X, df_y, scoring='f1', cv=cv)
            print("F1_score:",f1_score.mean())
            scores_result['f1_score'] = f1_score
        if score == 'auc':
            auc = cross_val_score(model, df_X, df_y, scoring='roc_auc', cv=cv)
            print("AUC:",auc.mean())
            scores_result['auc'] = auc
        if score == 'log_loss':
            log_loss = cross_val_score(model, df_X, df_y, scoring='neg_log_loss', cv=cv)
            print("log loss:",log_loss.mean(), log_loss.std())
            scores_result['log_loss'] = log_loss


    return scores_result

model_name=["gbm", ]
for name in model_name:
    print(name)
    model=eval(name)

    result = muti_score(X[filter_columns], y, model, cv, ['precision', 'recall', 'auc'])
    plt.plot(result['precision'])

plt.show()

#%%
#9 ouput config
config_params['filter_columns'] = filter_columns
with open("./513500_output.yml", 'w') as f:
    yaml.dump(config_params, f)

#%%
# 10 完整训练
current_path = os.path.abspath(".")
yaml_path2 = os.path.join(current_path, "513500_output.yml")
config_params2 = get_yaml_data(yaml_path2)
filter_columns = config_params2['filter_columns']

splita = int(len(X)*0.95)
splitb = int(len(X)*1) 

X1 = X.iloc[:splita]
y1 = y.iloc[:splita]
gbm.fit(X1[filter_columns],y1)

joblib.dump(gbm, './output/gbm.pkl')
logging.info('gbm.pkl')

#%% 11 输出结果

print(pd.DataFrame({
        'column': filter_columns,
        'importance': gbm.feature_importances_,
    }).sort_values(by='importance'))

# %%
X1.tail()

X1 = X1[filter_columns]

# %%

parameters = {
    'max_depth': range(4,10,2),
    'num_leaves': range(20, 170, 20), 
}

best_params = {
    'subsample': 0.8, 
    'colsample_bytree': 0.8, 
}

gbm=lgb.LGBMClassifier(**best_params,  n_estimators=100, is_unbalance=True, boosting_type='dart', random_state=2018)  #lgb

gsearch = GridSearchCV(gbm, param_grid=parameters, scoring='roc_auc', cv=cv)
gsearch.fit(X1, y1)

print('参数的最佳取值:{0}'.format(gsearch.best_params_))
print('最佳模型得分:{0}'.format(gsearch.best_score_))
print('mean: {:.4f}, std: {:.4f}'.format(gsearch.cv_results_['mean_test_score'].mean(), gsearch.cv_results_['std_test_score'].std()))
print(gsearch.cv_results_['params'])

best_params['max_depth'] = gsearch.best_params_['max_depth']
best_params['num_leaves'] = gsearch.best_params_['num_leaves']

best_params
#%%
#调整min_data_in_leaf 和 min_sum_hessian_in_leaf
parameters = {
    'min_child_samples': [18,19,20,21,22],
    'min_child_weight': [0.001,0.002, 0.003],
}

gbm=lgb.LGBMClassifier( **best_params, n_estimators=100, is_unbalance=True, boosting_type='dart', random_state=2018)  #lgb

gsearch = GridSearchCV(gbm, param_grid=parameters, scoring='roc_auc', cv=cv)
gsearch.fit(X1, y1)


print('参数的最佳取值:{0}'.format(gsearch.best_params_))
print('最佳模型得分:{0}'.format(gsearch.best_score_))
print('mean: {:.4f}, std: {:.4f}'.format(gsearch.cv_results_['mean_test_score'].mean(), gsearch.cv_results_['std_test_score'].std()))
print(gsearch.cv_results_['params'])

best_params['min_child_samples'] = gsearch.best_params_['min_child_samples']
best_params['min_child_weight'] = gsearch.best_params_['min_child_weight']

best_params

#%%
parameters = {
    'colsample_bytree': [0.5, 0.6, 0.7, 0.8, 0.9],
    'subsample': [0.6, 0.7, 0.8, 0.9, 1.0]
}


gbm=lgb.LGBMClassifier( **best_params, n_estimators=100, is_unbalance=True, boosting_type='dart', random_state=2018)  #lgb

gsearch = GridSearchCV(gbm, param_grid=parameters, scoring='roc_auc', cv=cv)
gsearch.fit(X1, y1)


print('参数的最佳取值:{0}'.format(gsearch.best_params_))
print('最佳模型得分:{0}'.format(gsearch.best_score_))
print('mean: {:.4f}, std: {:.4f}'.format(gsearch.cv_results_['mean_test_score'].mean(), gsearch.cv_results_['std_test_score'].std()))
print(gsearch.cv_results_['params'])
#%%
best_params['colsample_bytree'] = gsearch.best_params_['colsample_bytree']
best_params['subsample'] = gsearch.best_params_['subsample']

best_params
# %%
parameters = {
    'reg_alpha': [0, 0.001, 0.01, 0.03, 0.08, 0.3, 0.5],
    'reg_lambda': [0, 0.001, 0.01, 0.03, 0.08, 0.3, 0.5]
}


gbm=lgb.LGBMClassifier( **best_params, n_estimators=100, is_unbalance=True, boosting_type='dart', random_state=2018)  #lgb

gsearch = GridSearchCV(gbm, param_grid=parameters, scoring='roc_auc', cv=cv)
gsearch.fit(X1, y1)


print('参数的最佳取值:{0}'.format(gsearch.best_params_))
print('最佳模型得分:{0}'.format(gsearch.best_score_))
print('mean: {:.4f}, std: {:.4f}'.format(gsearch.cv_results_['mean_test_score'].mean(), gsearch.cv_results_['std_test_score'].std()))
print(gsearch.cv_results_['params'])

best_params['reg_alpha'] = gsearch.best_params_['reg_alpha']
best_params['reg_lambda'] = gsearch.best_params_['reg_lambda']

best_params

# %%
gbm.fit(X1,y1)

joblib.dump(gbm, './output/gbm.pkl')
logging.info('gbm.pkl')
# %%
