#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time     :2019/7/16 2:48 PM
# @Author   :Liuzhaoxiang


import re
import os
import requests
from bs4 import BeautifulSoup
from file_table import table_file_save

'''
article_file_save 获取文章的内容
url:    访问页面的域名地址
article_content:    需要解析的内容
save_path:  文件保存的路径
article_type:   当前股票文章类型
report_time:    当前股票文章发布时间
item_pdf:   文章的PDF路径
'''
def article_file_save(url, article_content, save_path, article_type, report_time, item_pdf):
    # 当前报告的名称
    report_name = article_content.string.replace("/", "")
    # 所有报告的路径
    if not os.path.exists(save_path):
        os.makedirs(save_path)
    # 单个详细报告的路径
    file_path = save_path + '/' + report_time + '++' + article_type + '++' + report_name
    if not os.path.exists(file_path):
        os.makedirs(file_path)

    # 报告详情的url
    detail_html = requests.get(url + article_content['href'])
    detail_html.encoding = 'gbk'
    detail_soup = BeautifulSoup(detail_html.text, "lxml")
    # 保存文章中的表数据
    table_file_save(file_path, detail_soup)

    # 包含标签的原始数据
    detail_content = detail_soup.find('div', id="content")
    contents = str(detail_content)
    # 去除html标签的数据 用于生成词云图片
    word_contents = re.sub(r'<.*?>', '', contents)
    # 保存原始数据
    with open(file_path + "/report_tag.txt", "w", encoding='UTF-8') as file_tag:
        file_tag.write(contents)
    # 保存去除html标签的数据
    with open(file_path + "/report_word.txt", "w", encoding='UTF-8') as file_word:
        file_word.write(word_contents)
    # 保存PDF文件路径
    with open(file_path + "/report_pdf.txt", "w", encoding='UTF-8') as file_pdf:
        file_pdf.write(str(item_pdf))
