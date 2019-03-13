class ContextsController < ApplicationController
  LIMIT_PAGE = 5

  def index
    public_page_user = User.find_by_username(params[:user_id])
    private_page_user = User.find_by_id(session[:user_id])
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

    # header_image
    @userInformation = UsersInformation.find_by_user_id(public_page_user.id)
    # 文章
    @articles = Article.where(:user_id => public_page_user.id )
    # 分頁
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
    # 限制筆數
    @articles = @articles.offset( ((@page - 1) * LIMIT_PAGE) ).limit(LIMIT_PAGE)

    #
    # @searchs = []
    # @articles.each do |article|
    #   @searchs << [article.id, article.title]
    # end
  end

  def new
    public_page_user = User.find_by_username(params[:user_id])
    private_page_user = User.find_by_id(session[:user_id])
    if session[:user_id].nil?
      # 未登入
      redirect_to root_path
    else
      # 已登入
      @private_page_user = private_page_user
      if public_page_user.id != session[:user_id]
        # 登入訪問別人
        @public_page_user = public_page_user
        #這篇違章不是你的
        redirect_to new_user_context_path(private_page_user.username)
      elsif public_page_user.id == session[:user_id]
        # 登入訪問自己
        #header_image
        @userInformation = UsersInformation.find_by_user_id(session[:user_id])
        @public_page_user = nil
        @article = Article.new
      else
        redirect_to new_user_context_path(private_page_user.username)
      end
    end
  end

  def create
    public_page_user = User.find_by_username(params[:user_id])
    private_page_user = User.find_by_id(session[:user_id])
    if session[:user_id].nil?
      # 未登入
      redirect_to root_path
    else
      # 已登入
      @private_page_user = private_page_user
      if public_page_user.id != session[:user_id]
        # 登入訪問別人
        @public_page_user = public_page_user
        #這篇違章不是你的
        redirect_to user_contexts_path(private_page_user.username)
      elsif public_page_user.id == session[:user_id]
        # 登入訪問自己
        #header_image
        @userInformation = UsersInformation.find_by_user_id(session[:user_id])
        @public_page_user = nil
        @Article = Article.new(context_params)
        @Article.user_id = session[:user_id]
        if @Article.save
          redirect_to user_context_path(private_page_user.username, @Article.slug)
        else
          render "new"
        end
      else
        redirect_to user_contexts_path(private_page_user.username)
      end
    end
  end

  def show
    public_page_user = User.find_by_username(params[:user_id])
    private_page_user = User.find_by_id(session[:user_id])
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
      else
        redirect_to root_path
      end
    end
    @article = Article.friendly.find_by_user_id_and_slug(public_page_user.id ,params[:id])
    @previous = Article.where("user_id = ? and id < ? ", public_page_user.id, @article.id).order(:id).last
    @next = Article.where("user_id = ? and id > ?", public_page_user.id, @article.id).order(:id).first
    #header_image
    @userInformation = UsersInformation.find_by_user_id(public_page_user.id)

  end

  def edit
    public_page_user = User.find_by_username(params[:user_id])
    private_page_user = User.find_by_id(session[:user_id])
    if session[:user_id].nil?
      # 未登入
      redirect_to root_path
    else
      # 已登入
      @private_page_user = private_page_user
      if public_page_user.id != session[:user_id]
        # 登入訪問別人
        @public_page_user = public_page_user
        #這篇違章不是你的
        redirect_to user_contexts_path(private_page_user.username)
      elsif public_page_user.id == session[:user_id]
        # 登入訪問自己
        #header_image
        @userInformation = UsersInformation.find_by_user_id(session[:user_id])
        @public_page_user = nil
        @article = Article.friendly.find_by_user_id_and_slug(session[:user_id], params[:id])
        if @article.nil?
          #你沒有這篇文章
          redirect_to user_contexts_path(private_page_user.username)
        end
      else
        redirect_to user_contexts_path(private_page_user.username)
      end
    end
  end

  def update
    public_page_user = User.find_by_username(params[:user_id])
    private_page_user = User.find_by_id(session[:user_id])
    if session[:user_id].nil?
      # 未登入
      redirect_to root_path
    else
      # 已登入
      @private_page_user = private_page_user
      if public_page_user.id != session[:user_id]
        # 登入訪問別人
        @public_page_user = public_page_user
        # 這篇文章不是你的
        redirect_to user_contexts_path(private_page_user.username)
      elsif public_page_user.id == session[:user_id]
        # 登入訪問自己
        @public_page_user = nil
        @article = Article.friendly.find_by_user_id_and_slug(session[:user_id], params[:id])
        if @article.update(params.require(:article).permit(:title, :author, :tag, :image, :context))
          redirect_to user_context_path(private_page_user.username, params[:id])
        else
          render :edit
        end
      else
        redirect_to user_contexts_path(private_page_user.username)
      end
    end
  end

  def destroy
    public_page_user = User.find_by_username(params[:user_id])
    private_page_user = User.find_by_id(session[:user_id])
    if session[:user_id].nil?
      # 未登入
      redirect_to root_path
    else
      # 已登入
      @private_page_user = private_page_user
      if public_page_user.id != session[:user_id]
        # 登入訪問別人
        @public_page_user = public_page_user
        # 這篇文章不是你的
        redirect_to user_contexts_path(private_page_user.username)
      elsif public_page_user.id == session[:user_id]
        # 登入訪問自己
        @public_page_user = nil
        @article = Article.friendly.find_by_user_id_and_slug(session[:user_id], params[:id])
        @article.destroy if @article
        redirect_to user_contexts_path(private_page_user.username)
      else
        redirect_to user_contexts_path(private_page_user.username)
      end
    end
  end

  private

  def context_params
      params.require(:article).permit(:title, :author, :tag, :image, :context )
  end

  def is_public_private
  end

end
