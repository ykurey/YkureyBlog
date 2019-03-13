class UsersController < ApplicationController

  layout "log_in", :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UsersInformation.create(:email => @user.email, :user_id => @user.id)
      Article.create(:user_id => @user.id, :title => "歡迎～", :author => "admin", :pentime => Date.today, :context => "這是您的第一篇文章")
      redirect_to root_url, :notice => "註冊成功"
    else
      render "new"
    end
  end

  def edit
    @public_page_user = nil
    url_user = User.find_by_username(params[:id])
    private_user = User.find_by_id(session[:user_id])
    if url_user.nil?
      if session[:user_id].nil?
        redirect_to root_path
      else
        # 已登入
        reUser = private_user.username
        redirect_to edit_user_path(reUser)
      end
    else
      if session[:user_id].nil?
        redirect_to root_path
      else
        # 已登入
        if session[:user_id] == url_user.id
          @private_page_user = private_user
          @userInformation = UsersInformation.find_by_user_id(session[:user_id])
        else
          reUser = private_user.userName
          redirect_to edit_user_path(reUser)
        end
      end
    end
  end

  def update
    puts params
    userInformation = UsersInformation.find_by_user_id(session[:user_id])
    if userInformation.update(params.require(:users_information).permit(:name, :email, :birthday, :phone, :address, :image, :header_image, :about))
      reUser = User.find_by_id(session[:user_id]).username
      redirect_to edit_user_path(reUser)
    else
      render :edit
    end
  end

  def show
    @user = User.find_by_username(params[:id])
    @userName = @user.username
    @userInformation = UsersInformation.find_by_user_id(@user.id)
  end


  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
