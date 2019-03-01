class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "註冊成功"
    else
      render "new"
    end
  end

  def show
    mail = User.find_by_email(params[:id])
    if session[:user_id] == mail.id
      @user = User.find_by_id(session[:user_id])
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
