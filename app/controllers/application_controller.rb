class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]
  #before_action :authenticate_user! ログインしていない状態で特定のページへ遷移させたい場合に使用する
  #except: [:top, :about] ログインしていないときどのページなら遷移できるか指定している。
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def after_sign_in_path_for(resource)
    user_path(resource)#ログイン後の遷移先指定
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
