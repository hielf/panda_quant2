class User < ApplicationRecord
  include AccountConcern
  # has_secure_password
  has_many :subscribtions, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :user_stock_list_rels
  has_many :stock_lists, :through => :user_stock_list_rels
  has_many :op_logs, dependent: :destroy

  # validates :openid, uniqueness: true, on: :create
  # validates :password, presence: true, length: {minimum: 6, maximum: 32}, format: {with: /\A[\x21-\x7e]+\Z/i, message: '密码至少6位'}, on: :create
  # validates :generate_username_prefix, presence: true, on: :create

  def op(type, message)
    log = self.op_logs.new(op_type: type, op_message: message, op_time: Time.now)
    log.save!
  end

  def last_op
    log = self.op_logs.last
    return log.op_type, log.op_message
  end

  def current_subscribtion
    self.subscribtions.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)
  end
end
