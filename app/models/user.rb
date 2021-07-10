class User < ApplicationRecord
  include AccountConcern
  validates_lengths_from_database
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
    message = message.slice(0..255) if (message != "" && !message.nil?)
    log = op_logs.new(op_type: type, op_message: message, op_time: Time.now)
    log.save!
  end

  def last_op
    log = op_logs.last
    return log.op_type, log.op_message
  end

  def current_subscribtion
    subscribtions.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)
  end

  def subscribing?(stock_list)
    user_stock_list_rels.find_by(stock_list_id: stock_list.id)
  end

  def subscribe!(stock_list)
    s = user_stock_list_rels.find_or_initialize_by(stock_list_id: stock_list.id)
    s.save!
  end

  def unsubscribe!(stock_list)
    user_stock_list_rels.where(stock_list_id: stock_list.id).delete_all
  end

end
