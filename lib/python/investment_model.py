# -*- coding:utf-8 -*-
# result = `python lib/python/investment_model.py '2018-01-22' '2019-02-27' ''300476.XSHE','002415.XSHE','512880.XSHG'' 252 1`
import sys, os
from jqdatasdk import *
sys.stdout = open(os.devnull, 'w')
auth('13817230201','JQ2melx2018')

import pandas as pd
import numpy as np
import statsmodels.api as sm #统计运算
import scipy.stats as scs #科学计算
import json

sys.stdout = sys.__stdout__

#建立statistics函数来记录重要的投资组合统计数据（收益，方差和夏普比）
#通过对约束最优问题的求解，得到最优解。其中约束是权重总和为1。
def statistics(weights):
    weights = np.array(weights)
    port_returns = np.sum(returns.mean()*weights)*risk_free
    port_variance = np.sqrt(np.dot(weights.T, np.dot(returns.cov()*risk_free,weights)))
    return np.array([port_returns, port_variance, port_returns/port_variance])

#最优化投资组合的推导是一个约束最优化问题
import scipy.optimize as sco
#最小化夏普指数的负值
def min_sharpe(weights):
    return -statistics(weights)[2]

def min_sharpe_opt(noa):
    #约束是所有参数(权重)的总和为1。这可以用minimize函数的约定表达如下
    cons = ({'type':'eq', 'fun':lambda x: np.sum(x)-1})
    #我们还将参数值(权重)限制在0和1之间。这些值以多个元组组成的一个元组形式提供给最小化函数
    bnds = tuple((0,1) for x in range(noa))
    #优化函数调用中忽略的唯一输入是起始参数列表(对权重的初始猜测)。我们简单的使用平均分布。
    opts = sco.minimize(min_sharpe, noa*[1./noa,], method = 'SLSQP', bounds = bnds, constraints = cons)
    opts

    data = {}
    # print("#最优化夏普指数")
    for i in range(noa):
        data[str(stock_set[i])] = opts['x'].round(4)[i]
        # print("股票代码:%s, 分配仓位%.4f" % (stock_set[i], opts['x'].round(4)[i]))
    # print("------")
    #预期收益率、预期波动率、最优夏普指数
    statistics(opts['x']).round(4)
    # print("预期收益率 %.4f" % statistics(opts['x']).round(3)[0])
    # print("预期波动率 %.4f" % statistics(opts['x']).round(3)[1])
    # print("最优夏普指数 %.4f" % statistics(opts['x']).round(3)[2])
    return json.dump(data, sys.stdout)

#投资组合优化2——方差最小
def min_variance(weights):
    # print("statistics:", statistics(weights)[1])
    return statistics(weights)[1]

def min_variance_opt(noa):
    cons = ({'type':'eq', 'fun':lambda x: np.sum(x)-1})
    bnds = tuple((0,1) for x in range(noa))
    optv = sco.minimize(min_variance, noa*[1./noa,],method = 'SLSQP', bounds = bnds, constraints = cons)
    optv

    optv['x'].round(3)
    data = {}
    # print('方差最小')
    for i in range(noa):
        data[str(stock_set[i])] = optv['x'].round(4)[i]
        print("股票代码:%s, 分配仓位%.4f" % (stock_set[i], optv['x'].round(4)[i]))
    # print("------")
    #预期收益率、预期波动率、最优夏普指数
    statistics(optv['x']).round(4)
    # print("预期收益率 %.4f" % statistics(optv['x']).round(3)[0])
    # print("预期波动率 %.4f" % statistics(optv['x']).round(3)[1])
    # print("最优夏普指数 %.4f" % statistics(optv['x']).round(3)[2])
    # print(str(json.dumps(data)))
    # return json.dumps(data)
    return json.dump(data, sys.stdout)

# usage
# python investment_model.py '2016-01-01' '2016-12-30' ''000001.XSHE','000063.XSHE','002007.XSHE','000001.XSHE','000002.XSHE''
if __name__ == "__main__":
    startDate = sys.argv[1]
    endDate = sys.argv[2]
    stock_set = sys.argv[3].split(',')
    period_profit =  int(sys.argv[4])
    opt_type =  int(sys.argv[5])

    # 最佳资产组合, 基于markowitz 理论框架, 根据过去一段时间内的相关资产表现, 给出不同预期下的最近资产配置比例

    # 输入预期持有的股票
    # stock_set = ['300476.XSHE','002415.XSHE','512880.XSHG']

    # 输入当前现金, RMB作为资产之一 ##TODO
    # 参数处理 临时
    # 增加货币基金，模拟空仓资金收益率(年化约2-3%)
    stock_set.append('159001.XSHE')

    # 输入每个股票未来收益预期修正, 收益预期修正基于AI统计 ##TODO
    #stock_set = fix_risk

    # 输入开始结束时间
    # startDate = '2018-01-22'
    # endDate = '2019-02-27'
    # 选择收益period长度, 默认 年化收益=252个交易日
    # period_profit = 252
    # 无风险利率, 银行年化收益基准 4%
    risk_free = 0.05

    # 获取数据集合
    noa = len(stock_set)
    df = get_price(stock_set, start_date = startDate, end_date = endDate, frequency='daily', fields=['close'])
    data = df['close']
    # data.rename(columns={'159001.XSHE': 'CASH'}, inplace=True)
    for n, i in enumerate(stock_set):
        if i == '159001.XSHE':
            stock_set[n] = 'CASH'

    # sLength = len(data)
    # array = []
    # rate = 0.0035/sLength
    # for index in range(sLength):
    #     array.append(rate)
    #     rate = rate + 0.0035/sLength
    #
    # n_data = pd.Series(array)
    # data = data.assign(cash=n_data.values)

    #每年252个交易日，用每日收益得到年化收益。计算投资资产的协方差是构建资产组合过程的核心部分。运用pandas内置方法生产协方差矩阵。
    returns = np.log(data / data.shift(1))
    print('年化利润率')
    print(returns.mean()*period_profit)

    # 看一下效果
    # print(returns.cov()*period_profit)

    #给不同资产随机分配初始权重
    weights = np.random.random(noa)
    weights /= np.sum(weights)
    # print(weights)
    #计算预期组合年化收益、组合方差和组合标准差
    np.sum(returns.mean()*weights)*period_profit
    np.dot(weights.T, np.dot(returns.cov()*period_profit,weights))
    np.sqrt(np.dot(weights.T, np.dot(returns.cov()* period_profit,weights)))

    if opt_type == 2:
        min_sharpe_opt(noa)
    else:
        min_variance_opt(noa)
