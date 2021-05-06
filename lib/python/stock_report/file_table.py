#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time     :2019/7/16 2:34 PM
# @Author   :Liuzhaoxiang

import os

'''
table_file_save 获取文章中的报表
save_path:    访问页面的域名地址
article_content:    需要解析的内容
'''
def table_file_save(save_path, article_content):
    # print('----------------------------------')
    table_soup = article_content.find_all(attrs={'class': 'table-wrap'})
    # 判断当前文章是否有表单
    if len(table_soup) > 0:
        for num in range(len(table_soup)):
            table_soup_1 = str(table_soup[num])
            # 表格上一个标签的内容
            pre_soup = table_soup[num].previous_sibling
            # 表格上一个标签的内容包含单位 则标签title取当前标签的上一个标签内容作为title
            include_1 = str(pre_soup.string).find('单位') >= 0
            include_2 = str(pre_soup.string).find('修订稿') >= 0
            if include_1 | include_2:
                sub_table_title = str(pre_soup.previous_sibling)
            else:
                sub_table_title = str(pre_soup)
            # 判断是p标签 则去除table副标题前的序号  /如果不是则直接拼接在上一个表格的后面
            if str(pre_soup.name) == 'p':
                # 但前可知参数有---> '、' -- ' ）'
                if sub_table_title.find('、') >= 0:
                    index_ = sub_table_title.find('、')
                    sub_title = '<p>' + sub_table_title[index_ + 1:]
                elif sub_table_title.find('）') >= 0:
                    index_ = sub_table_title.find('）')
                    sub_title = '<p>' + sub_table_title[index_ + 1:]
                else:
                    sub_title = sub_table_title
                #  将标题拼接在table表的前面
                tables = sub_title + table_soup_1
                # 记录当前表格的数据 如果下一个表格是紧随其后的就直接添加
                current_table = num
                with open(save_path + "/report_table_" + str(num) + ".txt", "w", encoding='UTF-8') as file:
                    file.write(tables)
            elif str(pre_soup.name) == 'div':
                table = table_soup_1
                with open(save_path + "/report_table_" + str(current_table) + ".txt", "a", encoding='UTF-8') as file:
                    file.write(table)
                # print('----------------------------------------')
