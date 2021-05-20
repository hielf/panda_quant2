class SmsJob < ApplicationJob
  queue_as :low_priority

  after_perform :around_check

  def perform(*args)
    @mobile        = args[0]
    @message_type  = args[1]
    @message       = args[2]

    last_sm = Sm.where("mobile = ? AND created_at > ?", @mobile, 1.minutes.ago).last

    if last_sm.nil?
      begin
        sign = Digest::MD5.hexdigest(@mobile.last(4))
        @sms = Sm.create!(mobile: @mobile, message_type: @message_type)
        @sms.send_code(sign)
      rescue Exception => ex
        Rails.logger.warn "#{ex.message}"
      end
    end
  end
# SmsJob.perform_later "1818559075", "verify_code", ""

  private
  def around_check
    @sms.update(updated_at: Time.now)
  end
end
