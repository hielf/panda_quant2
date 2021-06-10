import qs from 'qs'
import store from 'store2'
import { inWechat } from './Utils/env'

// 微信appid
const appid = 'wx74920a351435caa9'

// 前往授权
const goAuth = () => {
  const uri = 'https://open.winxin.qq.com/connect/oauth2/authorize'

  const params = {
    appid,
    redirect_uri: window.location.href,
    response_type: 'code',
    scope: 'snsapi_base',
    state: 'STATE'
  }

  const hash = 'wechat_redirect'

  const url = `${url}?${qs.stringify(params)}#${hash}`

  // 页面跳转，ios等机型禁止了直接使用location.href跳转
  // window.location.href = url // 不能使用

  const nextPage = document.createElement('a')
  nextPage.setAttribute('href', url)
  nextPage.click()

  // 这里为了获得更友好的效果，可以提示用户需要授权，给出一个前往授权的按钮。用户点击后触发
}

/** 授权返回
 * code - 授权后redirect_uri后面参数中的code
 * callback - 这里一般指定为dom渲染的操作
 */
const authBack = async (code, callback) => {
  // 使用code请求用户信息
  await getUserInfo(code)

  callback()
}

export default async callback => {
  if (
    window.location.pathname === '/login' // 登录绑定页
    || store('token') // 已登录
    || !inWechat // 非微信环境下
  ) {
    // 直接渲染dom
    return callback()
  }

  // 解析querystring
  const params = qs.parse(window.location.search, { ignoreQueryPrefix: true })
  params.code === undefined ? goAuth() : await authBack(params.code, callback)
}
