class SigninsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "登入成功"
    else
      flash.now.alert = "帳號或密碼錯誤"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "登出成功!"
  end

end
