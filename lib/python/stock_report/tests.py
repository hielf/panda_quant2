#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time     :2019/6/14 11:06 AM
# @Author   :Liuzhaoxiang

# exec("python3 /var/www/panda_quant/current/lib/python/stock_report/word_cloud.py #{font_path} #{str_text_path} #{str_image_path} #{str_create_pic_path}")
# system 'python3 /var/www/panda_quant/current/lib/python/stock_report/word_cloud.py', font_path, str_text_path, str_image_path, str_create_pic_path
# system( "python3 /var/www/panda_quant/current/lib/python/stock_report/word_cloud.py #{font_path}, #{str_text_path}, #{str_image_path}, #{str_create_pic_path}" )

import time
import os
from text_to_word_cloud import create_word_cloud

lib_path = os.path.abspath(os.path.join(os.getcwd(), os.pardir))
path = os.path.abspath(os.path.join(lib_path, os.pardir)) + '/tmp/stock_report/'

font_path = "/Users/hielf/workspace/projects/panda_quant/lib/python/stock_report/Hiragino-Sans-GB-W3.ttf"
str_text_path = "/Users/hielf/workspace/projects/panda_quant/tmp/stock_report/000007/2019-04-30++一季度报告（摘要）++全新好：2019年第一季度报告正文/report_word.txt"
str_image_path = '/Users/hielf/workspace/projects/panda_quant' + '/lib/python/stock_report/masks/3.png'
str_create_pic_path = "/Users/hielf/workspace/projects/panda_quant/tmp/stock_report/000007/2019-04-30++一季度报告（摘要）++全新好：2019年第一季度报告正文"

print(create_word_cloud(font_path, str_text_path, str_image_path, str_create_pic_path))
now = int(time.time())
print("当前时间戳:%s" % now)
local_time = time.localtime(now)
print(local_time)

date_format_localtime = time.strftime('%Y-%m-%d %H:%M:%S', local_time)
print("格式化时间之后为:%s" % date_format_localtime)

print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time())))
