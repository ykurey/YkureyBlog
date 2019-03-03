class UsersController < ApplicationController

  layout "login", :only => :new

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UsersInformation.create(:email => @user.email, :user_id => @user.id)
      puts "user的create"
      redirect_to root_url, :notice => "註冊成功"
    else
      render "new"
    end
  end

  def edit
    userName = User.find_by_username(params[:id])
    if userName.nil?
      reUser = User.find_by_id(session[:user_id]).username
      redirect_to edit_user_path(reUser)
    else
      if session[:user_id] == userName.id
        @userInformation = UsersInformation.find_by_user_id(session[:user_id])
      elsif session[:user_id].nil?
        redirect_to root_path
      else
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
    else
      render :edit
    end
  end

  def show
  end


  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
