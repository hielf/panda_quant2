import Bowser from 'bowser'

const parsed = Bowser.getParser(window.navigator.userAgent).parsedResult

// 是否微信环境
export const inWechat = parsed.browser.name === 'WeChat'

export const inIOS = parsed.os.name === 'iOS'

export const inSafari = parsed.browser.name === 'Safari'
