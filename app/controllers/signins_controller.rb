class SigninsController < ApplicationController

  def index

  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      user_email = User.find_by_id(user.id).email
      redirect_to user_path(user_email), :notice => "登入成功"
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
