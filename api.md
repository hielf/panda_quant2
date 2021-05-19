# REST API

***

## 认证格式
* HEADERS添加:
* Authorization: Token token="X4m2F/LwXWbJ5ekll1R5X+mJbudLC7AAgzrt8kKco60NGPVromAdrr9K0w/5dggmR0e+G/aRYvlcUuOSDS39nA==,mobile=18013999075

***

## 获取微信用户基本信息

***

## 调用方式
* Method: GET
* Need:

```
root_url/api/wechat_userinfo
```
* 参数: code(string)
* 输出: {   
    "openid":" OPENID",
    " nickname": NICKNAME,
    "sex":"1",
    "province":"PROVINCE"
    "city":"CITY",
    "country":"COUNTRY",
    "headimgurl":       "http://thirdwx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/46",
    "privilege":[ "PRIVILEGE1" "PRIVILEGE2"     ],
    "unionid": "o6_bmasdasdsad6_2sgVt7hMZOPfL"
}

***

## 获取小程序用户基本信息

***

## 调用方式
* Method: GET
* Need:

```
root_url/api/miniprogram_openid
```
* 参数: code(string)
* 输出: {"wechat_access_token"=>"EFu1bgTHWDabYvuEVkLWCA==", "openid"=>"o_iF85QZAWjlqREIc85WtM0klEFQ", "access_token"=>"X4m2F/LwXWbJ5ekll1R5X+mJbudLC7AAgzrt8kKco60NGPVromAdrr9K0w/5dggmR0e+G/aRYvlcUuOSDS39nA=="}

***

## 发送短信验证码

***

## 调用方式
* Method: POST
* Need:

```
root_url/api/users/send_verify
```
* 参数: mobile, sign
* sign算法: mobile后4位的md5小写
* 输出: {
    "status": 0,
    "message": "发送成功"
}

***

## 登录

***

## 调用方式
* Method: POST
* Need:

```
root_url/api/accounts/sign_in
```
* 参数: mobile(string), verify_code(string), openid(string)
* 输出: {
    "status": 0,
    "message": "登录成功",
    "user": {
        "id": 1,
        "mobile": "18018432577",
        "token": "X4m2F/LwXWbJ5ekll1R5X+mJbudLC7AAgzrt8kKco60NGPVromAdrr9K0w/5dggmR0e+G/aRYvlcUuOSDS39nA=="
    }
}

***

## 小程序登录

***

## 调用方式
* Method: POST
* Need:

```
root_url/api/accounts/miniprogram_sign_in
```
* 参数: openid(string), sessionkey(string), encrypteddata(string), iv(string)
* 输出: {
    "status": 0,
    "message": "登录成功",
    "data": {
        "openid": "o_iF85QZAWjlqREIc85WtM0klEFQ\"",
        "mobile": "13020112961",
        "failed_attempts": 0,
        "current_sign_in_at": "2019-07-06T04:03:21.000+08:00",
        "last_sign_in_at": "2019-07-06T04:00:55.000+08:00",
        "current_sign_in_ip": "::1",
        "last_sign_in_ip": "::1",
        "sign_in_count": 2,
        "locked_at": null,
        "access_token": "TVExiqje+Paj3r0TmBR4nELmOeQrg9JiaJzbiai7uulfcJOJVexgioEcNZt/BZWFwyEXqrjRYmhCC3cL4pQRWg==",
        "id": 3,
        "nickname": null,
        "password_digest": null,
        "created_at": "2019-07-06T03:51:39.000+08:00",
        "updated_at": "2019-07-06T04:03:21.000+08:00",
        "avatar": null
    }
}


***

## 创建attention(跳过验证)

***

## 调用方式
* Method: POST

```
root_url/attention
```
* 参数: package_type(string'基础套餐'|'高级套餐'), recommend_date(date_type推荐日期), stock_name(string), stock_code(string), note(string)
* 输出: {
    "status": 0,
    "message": "成功"
}

***

## 套餐列表

***

## 调用方式
* Method: GET
* Need:

```
root_url/api/packages
```
* 参数:
* 输出: {
    "status": 0,
    "message": "获取成功",
    "data": {
        "packages": [
            {
                "id": 1,
                "title": "包月套餐",
                "period": "月",
                "market_price": "150.0",
                "discount": "0.9",
                "real_price": "135.0",
                "package_type": "基础套餐",
                "desc": "熊猫宽课AI推荐股票30天"
            },
            {
                "id": 2,
                "title": "半年套餐",
                "period": "半年",
                "market_price": "800.0",
                "discount": "0.9",
                "real_price": "720.0",
                "package_type": "基础套餐",
                "desc": "熊猫宽课AI推荐股票180天"
            },
            {
                "id": 3,
                "title": "整年套餐",
                "period": "一年",
                "market_price": "1500.0",
                "discount": "0.9",
                "real_price": "1350.0",
                "package_type": "基础套餐",
                "desc": "熊猫宽课AI推荐股票365天"
            }
        ]
    }
}

***

## 订阅套餐

***

## 调用方式
* Method: POST
* Need: Auth

```
root_url/api/packages/subscribe
```
* 参数: package_id(套餐id)
* 输出: {
    "status": 0,
    "message": "订阅下单成功",
    "data": {
        "id": 12,
        "user_id": 1,
        "package_id": 1,
        "amount": "135.0",
        "status": "未支付",
        "created_at": "2018-04-24T13:05:00.000+08:00",
        "updated_at": "2018-04-24T13:05:00.000+08:00"
    }
}

***

## 微信预支付

***

## 调用方式
* Method: POST
* Need: Auth

```
root_url/api/orders/pre_pay
```
* 参数: id(订单 order.id), openid(微信openid,非必填)
* 输出: {
    "status": 0,
    "message": "下单成功",
    "data": {
        "appId": "wx74920a351435caa9",
        "package": "prepay_id=wx280052161238631bcc85faab2471811597",
        "nonceStr": "aqWA87EuDrFQVcbG",
        "timeStamp": "1524847936",
        "signType": "MD5",
        "paySign": "A91B1F32EAA4F234F5CC738928423692"
    }
}

***

## 个人信息

***

## 调用方式
* Method: GET
* Need: Auth

```
root_url/api/users/me
```
* 参数: 无
* 输出: {
    "status": 0,
    "message": "获取成功",
    "data": {
        "id": 1,
        "package": "基础套餐",
        "subscribe_date_num": 575,
        "created_at": "2018-04-18 02:51:02",
        "updated_at": "2018-05-03 22:02:56"
    }
}

***

## 模拟行情

***

## 调用方式
* Method: GET

```
root_url/random_bars
```
* 参数: start_date(开始日期,timeStamp), size(bar数量, int), duration(时间周期"1分钟、30分钟、60分钟",int), price(初始价格,float), change_rate(振幅“百分比”,int)
* 输出: {
    "status": 0,
    "message": "获取成功",
    "data": {
        "paginate_attrs": {
            "current_page": 1,
            "next_page": null,
            "prev_page": null,
            "total_pages": 1,
            "total_count": 1
        },
        "recommends": [
            {
                "recommend_date": "2018-04-18",
                "stocks": [
                    {
                        "stock_name": "浦发银行",
                        "stock_code": "600000",
                        "note": null,
                        "created_at": "2018-04-18 01:40:32",
                        "updated_at": "2018-04-18 01:40:32"
                    }
                ]
            }
        ]
    }
}

***

## 股票列表

***

## 调用方式
* Method: GET
* Need:

```
root_url/api/stock_lists
```
* 参数: char(string), query_type(string=all)
* 输出: {"status":0,"message":"获取成功","data":{"packages":[{"stock_list_id":1,"code":"000600","name":"建投能源","market":"深A"},{"code":"002600","name":"领益智造","market":"深A"},{"code":"166001","name":"中欧趋势","market":"深A"},{"code":"166006","name":"中欧成长","market":"深A"},{"code":"166008","name":"中欧强债","market":"深A"}]}}

***

## 用户研报访问历史

***

## 调用方式
* Method: GET
* Need: Authorization

```
root_url/api/stock_lists/user_history
```
* 参数:
* 输出: {"status":0,"message":"获取成功","data":{"history":[{"code":"000600","name":"建投能源","market":"深A"},{"code":"002600","name":"领益智造","market":"深A"},{"code":"166001","name":"中欧趋势","market":"深A"},{"code":"166006","name":"中欧成长","market":"深A"},{"code":"166008","name":"中欧强债","market":"深A"}]}}


***

## 读取研报

***

## 调用方式
* Method: GET
* Need: Authorization

```
root_url/api/stock_reports/:id
```
* 参数: id(integer)
* 输出: {
    "status": 0,
    "message": "stock_report",
    "data": {
        "stock_report_id": 4,
        "title": "全新好：2018年年度报告摘要",
        "read_count": 4,
        "report_date": "2019-04-30",
        "report_type": "年度报告（摘要）",
        "report_img": "pandastatic.ripple-tech.com/FtxhSzIFh5YR5bVhZjB6TPs8NJiB",
        "pdf_url": "http://file.finance.sina.com.cn/211.154.219.97:9494/MRGG/CNSESZ_STOCK/2019/2019-4/2019-04-30/5331000.PDF",
        "report_tables": [
            {
                "table_html": "<p>财务状况及未来发展规划，投资者应当到证监会指定媒体仔细阅读年度报告全文。董事、监事、高级管理人员异议声明</p><div class=\"table-wrap\"><table border=\"1\"><tr><td colspan=\"1\" rowspan=\"1\" width=\"145\">姓名</td><td colspan=\"1\" rowspan=\"1\" width=\"145\">职务</td><td colspan=\"1\" rowspan=\"1\" width=\"185\">内容和原因</td></tr></table></div>"
            },
            {
                "table_html": "<p>声明除下列董事外，其他董事亲自出席了审议本次年报的董事会会议</p><div class=\"table-wrap\"><table border=\"1\"><tr><td colspan=\"1\" rowspan=\"1\" width=\"119\">未亲自出席董事姓名</td><td colspan=\"1\" rowspan=\"1\" width=\"119\">未亲自出席董事职务</td><td colspan=\"1\" rowspan=\"1\" width=\"119\">未亲自出席会议原因</td><td colspan=\"1\" rowspan=\"1\" width=\"119\">被委托人姓名</td></tr></table></div>"
            }
        ],
        "created_at": "2019-07-31 14:29:15",
        "updated_at": "2019-08-01 15:53:25"
    }
}
