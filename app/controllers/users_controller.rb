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

  def edit
    mail = User.find_by_email(params[:id])
    if mail.nil?
      reUser = User.find_by_id(session[:user_id]).email
      redirect_to edit_user_path(reUser)
    else
      if session[:user_id] == mail.id
        @userInformation = UsersInformation.find_by_user_id(session[:user_id])
      elsif session[:user_id].nil?
        redirect_to root_path
      else
        reUser = User.find_by_id(session[:user_id]).email
        redirect_to edit_user_path(reUser)
      end
    end
  end

  def update
    puts params
    userInformation = UsersInformation.find_by_user_id(session[:user_id])
    if userInformation.update(params.require(:users_information).permit(:name, :email, :birthday, :phone, :address, :about))
      reUser = User.find_by_id(session[:user_id]).email
      redirect_to edit_user_path(reUser)
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
