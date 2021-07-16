class NotificationJob < ApplicationJob
  queue_as :push_notifications

  after_perform :around_check

  def perform(*args)
    @id = args[0]

    @notification = PushNotification.find(@id)

    if @notification
      begin

      rescue Exception => ex
        @notification.failed
        Rails.logger.warn "#{ex.message}"
      end
    end
  end

  private
  def around_check
    @notification.sent
  end
end
