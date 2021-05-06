#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time     :2019/7/18 4:01 PM
# @Author   :Liuzhaoxiang



import requests
import time
import datetime
import os
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor
from file_article import article_file_save
result = []
start = time.clock()  # 计时-开始
# lib_path = os.path.abspath(os.path.join(os.getcwd(), os.pardir))
# path = os.path.abspath(os.path.join(lib_path, os.pardir)) + '/tmp/stock_report/'
list_all = list(range(1, 3, 1))
# path = '/Users/hielf/workspace/projects/panda_quant/lib/python/stock_report/'

today = datetime.datetime.now().date()


def get_stock(stock_code, path):
    list1 = []
    codes = stock_code
    sum = multiThreading(list1, codes, path)
    # print(list1)
    # 计时-结束
    end = time.clock()
    print(("爬取完成 用时：%s" % (end - start)))
    print('总爬取 %d 页 ' % (sum))
    while None in result:
        result.remove(None)
    # print(result)
    # print(list_all)
    # with open("test.txt", "w", encoding="UTF-8") as f:
    #     for thing in result:
    #         f.write(thing)
    #         f.write('\r\n')


# 多线程
def multiThreading(list1, codes, path):
    sum = 1
    while sum <= 2:
        with ThreadPoolExecutor(max_workers=1) as executor:
            for result in executor.map(do, [sum], [path], [codes]):
                sum += 1
    return sum


def do(i, path, codes):
    try:
        stock_path = path
        urls = 'http://vip.stock.finance.sina.com.cn'
        html = requests.get(urls + '/corp/view/vCB_BulletinGather.php?stock_str=' + codes + '&page=' + str(i))
        html.encoding = 'gbk'
        soup = BeautifulSoup(html.text, "lxml")
        for tr in soup.select('table tbody tr'):
            if len(tr.select('th a')) > 1:
                item_pdf = tr.select('th a')[1]['href']
            else:
                item_pdf = 'This Report Without PDF File'
            item_a_tag = tr.select('th a')[0]
            article_type = tr.select('td')[0].string
            report_time = tr.select('td')[1].string
            report_title = str(report_time + "/" + article_type + "/" + tr.select('th a')[0].string)
            # print(report_title)
            if (today - datetime.datetime.strptime(report_time, '%Y-%m-%d').date()).days > 180:
                print(report_time + "ignored")
                continue
            else:
                if article_type.find("报告") != -1:
                    article_file_save(urls, item_a_tag, stock_path, article_type, report_time, item_pdf)
                    result.append(report_title)
        # list_all.remove(i)
    except:
        pass
