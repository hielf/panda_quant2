# encoding: utf-8
require 'pycall/import'
include PyCall::Import
include Base64

module ApplicationHelper

  def strftime_time(time_obj)
    time_obj.strftime('%Y-%m-%d %H:%M:%S')
  end

  def paginate_attrs(json, object)
    json.(object, :current_page, :next_page, :prev_page, :total_pages, :total_count)
  end

  def quote_change(open_price, current_price)
    if !open_price.nil? && open_price > 0
      s = ((current_price.to_f - open_price.to_f).to_f / open_price.to_f * 100).to_f.round(2).to_s + "%"
      if current_price.to_f > open_price.to_f
        "+" + s
      else
        s
      end
    else
      "-"
    end
  end

  # pyimport 'pyaes'
  # pyimport 'base64'
  # pyimport 'sys'
  # sys.path.insert(0, '/usr/local/opt/python/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/Cryptodome')
  # pyfrom :'Cryptodome.Cipher', import: :AES
  # pyfrom :'importlib', import: :util
  # AES = importlib.util.spec_from_file_location("AES", "/usr/local/opt/python/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/Cryptodome/Cipher/AES.py")
  #
  # PyCall.sys.path.append File.dirname("/usr/local/opt/python/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/Cryptodome/Cipher/AES.py")
  # aes = PyCall.import_module('AES')
  #
  # encryptedData = "OFpbvttFBBV52gUFolY3jOZZutgWUNb+Qsqx/epgTfGETg82UtrXU4oC30KNsZKmAhIFS5lUjtfFK+tigSL3FMkFv9CqZEEBlZxN8/uNIsib+Dqo9tkfn1vRqgjm/b1VIL02v0ml7/jYzuihRRyiEOIZc5tZhyXJXj/rN9jNfbeF7WYBxnEJ43pTERHpFrkYbBSZgJGH2v0Egdo/QcI16w=="
  # iv = "iSLCIPHFzxjEHuPOSxOYcA=="
  # sessionKey = 'BDMzFJtpb856gVAjADGqGw=='
  # appId = 'wx33c286af210b412d'

  # aes = pyaes.AESModeOfOperationCBC(sessionKey, iv = iv)
  # aes.decrypt(encryptedData)

  def wxdata_decrypt(appId, sessionKey, encryptedData, iv)
    Rails.logger.warn PyCall::PYTHON_VERSION
    pyimport 'base64'
    Rails.logger.warn "base64 ready"
    pyimport 'json'
    Rails.logger.warn "json ready"
    pyimport 'sys'
    # sys.path.insert(0, '/home/deploy/.local/lib/python3.7/site-packages/Cryptodome')
    case Rails.env
    when "production"
      PyCall.sys.path.append File.dirname("/home/deploy/.local/lib/python3.7/site-packages/Cryptodome/Cipher/AES.py")
    else
      PyCall.sys.path.append File.dirname("/usr/local/opt/python/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/Cryptodome/Cipher/AES.py")
    end
    aes = PyCall.import_module('AES')
    # pyfrom 'Cipher', import: :AES
    Rails.logger.warn "AES ready"

    sessionKey = base64.b64decode(sessionKey)
    # sessionKey = urlsafe_decode64(sessionKey)

    Rails.logger.warn "sessionKey: #{sessionKey}"
    encryptedData = base64.b64decode(encryptedData)
    # encryptedData = urlsafe_decode64(encryptedData)
    Rails.logger.warn "encryptedData: #{encryptedData}"
    iv = base64.b64decode(iv)
    # iv = urlsafe_decode64(iv)
    Rails.logger.warn "iv: #{iv}"
    sk = PyCall.eval "str('#{sessionKey}')"
    v = PyCall.eval "str('#{iv}')"

    cipher = aes.new(sk, aes.MODE_CBC, v)
    Rails.logger.warn "cipher: #{cipher}"

    s = cipher.decrypt(encryptedData)
    Rails.logger.warn "s: #{s}"

    decrypted = JSON.parse(unpad(s))

    Rails.logger.warn "decrypted: #{decrypted}"

    if decrypted['watermark']['appid'] != appId
      return false
    else
      return decrypted
    end
  end

  def wxdata_decrypt_ruby(appId, sessionKey, encryptedData, iv)

    sk = Base64.strict_decode64(sessionKey)
    # Rails.logger.warn "sessionKey: #{sk}"
    # ed = urlsafe_decode64(encryptedData)
    # encryptedData = Base64.strict_decode64(encryptedData)
    begin
      encryptedData = Base64.strict_decode64(encryptedData) # decode data
      # ...
    rescue ArgumentError => e
      Rails.logger.warn "Could not decrypt data: #{e}, #{encryptedData}"
    end
    # Rails.logger.warn "encryptedData: #{ed}"
    v = Base64.strict_decode64(iv)
    # Rails.logger.warn "iv: #{v}"

    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    Rails.logger.warn "cipher: #{cipher}"
    cipher.decrypt
    cipher.key = sk
    cipher.iv = v
    s = cipher.update(encryptedData) + cipher.final

    Rails.logger.warn "s: #{s}"

    decrypted = JSON.parse(s)

    Rails.logger.warn "decrypted: #{decrypted}"

    if decrypted['watermark']['appid'] != appId
      return false
    else
      return decrypted
    end
  end

  def unpad(s)
    a = (0 ... s.length).find_all { |i| s[i,1] == '}' }
    pos = a.max
    return s[0..pos]
    # return s.gsub(/\a+$/, '')
  end
end
