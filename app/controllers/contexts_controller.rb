class ContextsController < ApplicationController
  LIMIT_PAGE = 5

  def index
    # puts "123"
    # puts session[:user_id].present?
    # puts "---"
    #
    # @re = Article.where(:user_id => session[:user_id])
    # @re.each do |uu|
    #   puts uu.title
    # end
    #
    # puts "---"
    # @c8 = Article.find_by_sql("select * from articles where user_id = '#{session[:user_id]}' ")
    # @c8.each do |oo|
    #   puts oo.title
    # end

    # @ppa = Article.where(:user_id => params[:user_id])
    # puts @ppa.first.title


    @user = User.find_by_username(params[:user_id])
    @userName = @user.username
    @articles = Article.where(:user_id => @user.id )
    @first_page = 1
    if(@articles.count % LIMIT_PAGE != 0)
      @last_page = ( @articles.count / LIMIT_PAGE ) + 1
    else
      @last_page = ( @articles.count / LIMIT_PAGE )
    end

    if params[:page]
      @page = params[:page].to_i
    else
      @page = 1
    end

    @searchs = []
    @articles.each do |article|
      @searchs << [article.id, article.title]
    end

  #        限制筆數
    @articles = @articles.offset( ((@page - 1) * LIMIT_PAGE) ).limit(LIMIT_PAGE)
  end

  def show
    user_id = User.find_by_username(params[:user_id]).id
    @article = Article.find_by_user_id_and_id(user_id, params[:id])
    @previous = Article.where("user_id = ? and id < ?", user_id, params[:id]).order(:id).first
    @next = Article.where("user_id = ? and id > ?", user_id, params[:id]).order(:id).first
  end

  def edit
    user_id = User.find_by_username(params[:user_id]).id
    if session[:user_id].nil?
      #未登入
      redirect_to root_path
    else
      session_user_userName = User.find_by_id(session[:user_id]).username
      if session[:user_id] == user_id
        @article = Article.find_by_user_id_and_id(session[:user_id], params[:id])
        if @article.nil?
          #你沒有這篇文章
          redirect_to user_contexts_path(session_user_userName)
        end
      else
        #這篇違章不是你的
        redirect_to user_contexts_path(session_user_userName)
      end
    end
  end

  def update
  end

  private
  # def tesa
  #     @tesa ||= session[:user_id]
  # end
end
