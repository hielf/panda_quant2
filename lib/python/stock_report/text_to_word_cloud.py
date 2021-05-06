#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time     :2019/6/14 11:31 AM
# @Author   :Liuzhaoxiang

import re  # 正则表达式库
import collections  # 词频统计库
import numpy as np  # numpy数据处理库
import jieba  # 结巴分词
import wordcloud  # 词云展示库
from PIL import Image  # 图像处理库
import matplotlib.pyplot as plt  # 图像展示库
import time


def create_word_cloud(font_path, text_path, image_path, pic_path):
    # 读取文件
    fn = open(text_path, encoding="utf-8")  # 打开文件
    string_data = fn.read()  # 读出整个文件
    fn.close()  # 关闭文件

    # 文本预处理
    pattern = re.compile(u'\t|\n|\.|-|:|;|\)|\(|\?|"')  # 定义正则表达式匹配模式
    string_data = re.sub(pattern, '', string_data)  # 将符合模式的字符去除

    # 文本分词
    seg_list_exact = jieba.cut(string_data, cut_all=False)  # 精确模式分词
    object_list = []
    remove_words = [u'的', u'，', u'和', u'是', u'随着', u'对于', u'对', u'等', u'能', u'都', u'。',
                    u' ', u'、', u'中', u'在', u'了', u'通常', u'如果', u'我们', u'需要', u'年', u',', u'其他',
                    u'（', u'）', u'：', u'公司', u'—', u'为', u'有限公司', u'本', u'月', u'亿', u'万',
                    u'1', u'2', u'；', u'上', u'“', u'”', u'《', u'》', u'问询', u'书', u'报告', u'或',
                    u'且', u'日', u'有', u'及', u'非', u'000', u'元', u'续', u'不', u'与', u'/', u'□',
                    u'万元', u'亿元', u'√', u'投', u'无', u'人', u'=', u'>', u'<', u'情况', u'系'
                    , u'指', u'个', u'号', u'－', u'．']  # 自定义去除词库

    for word in seg_list_exact:  # 循环读出每个分词
        if word not in remove_words:  # 如果不在去除词库中
            object_list.append(word)  # 分词追加到列表

    # 词频统计
    word_counts = collections.Counter(object_list)  # 对分词做词频统计
    word_counts_top10 = word_counts.most_common(10)  # 获取前10最高频的词
    print(word_counts_top10)  # 输出检查

    # 词频展示
    mask = np.array(Image.open(image_path))  # 定义词频背景图
    wc = wordcloud.WordCloud(
        background_color='white',  # 设置背景颜色
        prefer_horizontal=1,
        font_path=font_path,  # 设置字体格式
        mask=mask,  # 设置背景图
        max_words=400,  # 最多显示词数
        max_font_size=100,  # 字体最大值
        scale=8  # 调整图片清晰度，值越大越清楚
    )

    wc.generate_from_frequencies(word_counts)  # 从字典生成词云
    image_colors = wordcloud.ImageColorGenerator(mask)  # 从背景图建立颜色方案
    wc.recolor(color_func=image_colors)  # 将词云颜色设置为背景图方案
    now = int(time.time())
    img_name = str(now) + '.jpg'  # 图片名
    wc.to_file(pic_path + img_name)  # 将图片输出为文件
    # plt.imshow(wc)  # 显示词云
    plt.axis('off')  # 关闭坐标轴
    # plt.show()  # 显示图像
    return pic_path + img_name
