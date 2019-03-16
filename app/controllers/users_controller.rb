class UsersController < ApplicationController

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
          @article_size = Article.where(:user_id => session[:user_id] ).count
        else
          redirect_to edit_user_path(private_user.username)
        end
      end
    end
  end

  def update
    @public_page_user = nil
    url_user = User.find_by_username(params[:id])
    private_user = User.find_by_id(session[:user_id])
    if session[:user_id].nil?
      # 未登入
      redirect_to root_path
    else
      if session[:user_id] == url_user.id
        userInformation = UsersInformation.find_by_user_id(session[:user_id])
        if userInformation.update(params.require(:users_information).permit(:name, :email, :birthday, :school, :github, :facebook, :twitter, :instagram, :image, :header_image, :about))
          redirect_to edit_user_path(private_user.username)
        else
          render :edit
        end
      else
        redirect_to edit_user_path(private_user.username)
      end
    end
  end

  def show
    public_page_user = User.find_by_username(params[:id])
    private_page_user = User.find_by_id(session[:user_id])
    if public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      if session[:user_id].nil?
        # 未登入
        @public_page_user = public_page_user
      else
        # 已登入
        @private_page_user = private_page_user
        if public_page_user.id != session[:user_id]
          # 登入訪問別人
          @public_page_user = public_page_user
        elsif public_page_user.id == session[:user_id]
          # 登入訪問自己
          @public_page_user = nil
        end
      end
      @article_size = Article.where(:user_id => public_page_user.id ).count
      @userInformation = UsersInformation.find_by_user_id(public_page_user.id)
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
