require 'qiniu'
Qiniu.establish_connection! access_key: ENV['qiniu_accesskey'],
                            secret_key: ENV['qiniu_serect']
