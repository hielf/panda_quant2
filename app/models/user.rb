class User < ApplicationRecord
  include AccountConcern
  # has_secure_password
  has_many :subscribtions, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :user_stock_list_rels
  has_many :stock_lists, :through => :user_stock_list_rels

  # validates :openid, uniqueness: true, on: :create
  # validates :password, presence: true, length: {minimum: 6, maximum: 32}, format: {with: /\A[\x21-\x7e]+\Z/i, message: '密码至少6位'}, on: :create
  # validates :generate_username_prefix, presence: true, on: :create


end
