class UsersController < ApplicationController
  before_action :is_public_private, only: [:edit, :update, :show]
  layout "log_in", :only => [:new, :create]

  def new
    @user = User.new
    @page_title = "註冊"
  end

  def create
    @page_title = "註冊"
    @user = User.new(user_params)
    if @user.save
      UsersInformation.create(:email => @user.email, :user_id => @user.id)
      Article.create(:user_id => @user.id, :title => "歡迎～", :author => "admin", :tag => "你的第一篇", :pentime => Time.zone.now, :context => "這是您的第一篇文章")
      redirect_to root_url, :notice => "註冊成功"
    else
      flash.now.alert = "註冊失敗"
      render "new"
    end
  end

  def edit
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      if session[:user_id].nil?
        # 未登入
        redirect_to root_path
      else
        # 已登入
        if session[:user_id] == @public_page_user.id
          @public_page_user = nil
          @userInformation = UsersInformation.find_by_user_id(session[:user_id])
          @article_size = Article.where(:user_id => session[:user_id] ).count
        else
          redirect_to edit_user_path(@private_page_user.username)
        end
      end
    end
  end

  def update
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      if session[:user_id].nil?
        # 未登入
        redirect_to root_path
      else
        if session[:user_id] == @public_page_user.id
          @public_page_user = nil
          userInformation = UsersInformation.find_by_user_id(session[:user_id])
          if userInformation.update(users_informations_params)
            redirect_to edit_user_path(@private_user.username)
          else
            render :edit
          end
        else
          redirect_to edit_user_path(@private_user.username)
        end
      end
    end
  end

  def show
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      @article_size = Article.where(:user_id => @public_page_user.id ).count
      @userInformation = UsersInformation.find_by_user_id(@public_page_user.id)
      if session[:user_id].nil?
        # 未登入
      else
        # 已登入
        if @public_page_user.id != session[:user_id]
          # 登入訪問別人
        elsif @public_page_user.id == session[:user_id]
          # 登入訪問自己
          @public_page_user = nil
        end
      end
      @page_title = @userInformation.name
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def users_informations_params
    params.require(:users_information).permit(:name, :email, :birthday, :school, :github, :facebook, :twitter, :instagram, :image, :header_image, :about)
  end

  def is_public_private
    @public_page_user = User.find_by_username(params[:id])
    @private_page_user = User.find_by_id(session[:user_id])
    if @public_page_user.present?
      @common＿lock = @public_page_user
    else
      @common＿lock = @private_page_user
    end
  end
end
