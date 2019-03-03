class UsersController < ApplicationController

  layout "login", :only => :new

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
    userName = User.find_by_username(params[:id])
    puts "---"
    if userName.nil?
      puts "-1-"
      reUser = User.find_by_id(session[:user_id]).username
      redirect_to edit_user_path(reUser)
    else
      if session[:user_id] == userName.id
        puts "-2-"
        @userInformation = UsersInformation.find_by_user_id(session[:user_id])
      elsif session[:user_id].nil?
        redirect_to root_path
      else
        puts "-3-"
        reUser = User.find_by_id(session[:user_id]).userName
        redirect_to edit_user_path(reUser)
      end
    end
  end

  def update
    puts params
    userInformation = UsersInformation.find_by_user_id(session[:user_id])
    if userInformation.update(params.require(:users_information).permit(:name, :email, :birthday, :phone, :address, :about))
      reUser = User.find_by_id(session[:user_id]).username
      redirect_to edit_user_path(reUser)
      puts "update 成功"
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
