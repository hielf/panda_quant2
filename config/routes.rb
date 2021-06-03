Rails.application.routes.draw do
  root 'home#index'
  get 'hello_world', to: 'hello_world#index'
  resource :wechat, only: [:show, :create]
  resources :users
  namespace :api, defaults: {format: :json} do
    root 'root#home'
    post 'accounts/sign_in', to: 'accounts#sign_in'
    post 'accounts/miniprogram_sign_in', to: 'accounts#miniprogram_sign_in'
    post 'accounts/sign_out', to: 'accounts#sign_out'
    get 'wechat_access_token', to: 'root#wechat_access_token'
    get 'wechat_userinfo', to: 'root#wechat_userinfo'
    get 'miniprogram_openid', to: 'root#miniprogram_openid'
    get 'wechat_get_token', to: 'root#wechat_get_token'
    resources :users, except: [:edit, :new] do
      collection do
        post :send_verify
        get :me
      end
    end
    resources :packages do
      collection do
        post :subscribe
      end
    end
    resources :orders do
      collection do
        post :pre_pay
        post :notify
      end
    end
    resources :stock_lists do
      collection do
        get :user_history
      end
    end
    # resources :trade_orders do
    #   collection do
    #     post :order
    #   end
    # end
    match '*path', via: :all, to: 'root#route_not_found'
  end
  match '*path', via: :all, to: 'home#route_not_found'

end
