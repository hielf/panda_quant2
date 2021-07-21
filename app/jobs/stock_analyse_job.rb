class StockAnalyseJob < ApplicationJob
  queue_as :first

  after_perform :new_user_package

  def perform(*args)
    @stock_code = args[0]
    @duration   = args[1]

    data = ApplicationController.helpers.jq_data_bar_http(@stock_code, @duration, 10)

    if ApplicationController.helpers.csv_row_check(@stock_code, @duration)
      if data
        tmp_file = ApplicationController.helpers.data_to_csv(data, @stock_code, @duration)
        file = ApplicationController.helpers.merge_csv(@stock_code, @duration)
      end
    else
      if data
        file = ApplicationController.helpers.data_to_csv(data, @stock_code, @duration, false)
      end
    end

    find_w_flag = ApplicationController.helpers.find_w(@stock_code, @duration)
    
    if find_w_flag != false
      stock_analyse = find_w_flag
      stock_list = Stock_list.find_by(stock_code: stock_analyse.stock_code)
      users = stock_list.watching_users(@duration)

      users.each do |user|
        begin
          notification = user.push_notifications.new(
            note_type: "推送通知",
            stock_code: stock_analyse.stock_code,
            stock_display_name: stock_analyse.stock_display_name,
            duration: stock_analyse.duration,
            begin_time: stock_analyse.begin_time,
            end_time: stock_analyse.end_time,
            stock_analyse_id: stock_analyse.id
          )
          if notification.save!
            NotificationJob.perform_later notification.id
          end
        rescue Exception => e
          Rails.logger.warn "StockAnalyseJob failed: #{e}"
        end
      end
    end
  end
# Job.perform_later "1818559075", "verify_code", ""

  private
  def new_user_package
    # user.current_subscribtion.package_type
    # Subscribtion.where(package_type: "新手礼包").each do |sub|
    #   user = sub.user
    # end
  end
end
