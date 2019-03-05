class SigninController < ApplicationController
  layout "login"

  def index
    if session[:user_id] != nil
      user_username = User.find_by_id(session[:user_id]).username
      redirect_to edit_user_path(user_username)
    end
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      user_username = User.find_by_id(user.id).username
      # redirect_to user_path(user_email), :notice => "登入成功"
      redirect_to edit_user_path(user_username)
    else
      flash.now.alert = "帳號或密碼錯誤"
      render "index"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "登出成功!"
  end
end
