class ContextsController < ApplicationController
  before_action :is_public_private, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  LIMIT_PAGE = 5

  def index
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      # header_image
      @userInformation = UsersInformation.find_by_user_id(@public_page_user.id)
      @page_title = @userInformation.name
      # 文章
      if params[:search_title].blank?
        @articles = Article.where(:user_id => @public_page_user.id )
      elsif params[:search_title].present?
        @articles = Article.search_title(@public_page_user.id, "%#{params[:search_title]}%")
      end

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

    # @searchs = []
    # @articles.each do |article|
    #   @searchs << [article.id, article.title]
    # end
  end

  def new
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      if session[:user_id].nil?
        # 未登入
        redirect_to root_path
      else
        # 已登入
        if @public_page_user.id != session[:user_id]
          # 登入訪問別人
          #這篇違章不是你的
          redirect_to root_path
        elsif @public_page_user.id == session[:user_id]
          # 登入訪問自己
          #header_image
          @userInformation = UsersInformation.find_by_user_id(session[:user_id])
          @public_page_user = nil
          @article = Article.new
        else
          redirect_to root_path
        end
      end
    end
  end

  def create
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      if session[:user_id].nil?
        # 未登入
        redirect_to root_path
      else
        # 已登入
        if @public_page_user.id != session[:user_id]
          # 登入訪問別人
          #這篇文章不是你的
          redirect_to root_path
        elsif @public_page_user.id == session[:user_id]
          # 登入訪問自己
          #header_image
          @userInformation = UsersInformation.find_by_user_id(session[:user_id])
          @public_page_user = nil
          @Article = Article.new(context_params)
          @Article.pentime = Time.zone.now
          @Article.user_id = session[:user_id]
          if @Article.save
            redirect_to user_context_path(@private_page_user.username, @Article.slug)
          else
            flash.now.alert = "新增失敗"
            render "new"
          end
        end
      end
    end
  end

  def show
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      #header_image
      @userInformation = UsersInformation.find_by_user_id(@public_page_user.id)
      @article = Article.friendly.find_by_user_id_and_slug(@public_page_user.id ,params[:id])
      if @article.nil?
        redirect_to root_path
      else
        # @previous = Article.where("user_id = ? and id < ? ", @public_page_user.id, @article.id).order(:id).last
        @previous = Article.back_page(@public_page_user.id, @article.id, :id)
        # @next = Article.where("user_id = ? and id > ?", @public_page_user.id, @article.id).order(:id).first
        @next = Article.next_page(@public_page_user.id, @article.id, :id)
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
      end
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
        if @public_page_user.id != session[:user_id]
          # 登入訪問別人
          #這篇違章不是你的
          redirect_to root_path
        elsif @public_page_user.id == session[:user_id]
          # 登入訪問自己
          #header_image
          @userInformation = UsersInformation.find_by_user_id(session[:user_id])
          @public_page_user = nil
          @article = Article.friendly.find_by_user_id_and_slug(session[:user_id], params[:id])
          if @article.nil?
            #你沒有這篇文章
            redirect_to root_path
          end
        end
      end
    end
  end

  def update
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      # 已登入
      if @public_page_user.id != session[:user_id]
        # 登入訪問別人
        # 這篇文章不是你的
        redirect_to root_path
      elsif @public_page_user.id == session[:user_id]
        # 登入訪問自己
        @public_page_user = nil
        @article = Article.friendly.find_by_user_id_and_slug(session[:user_id], params[:id])
        if @article.update(context_params)
          redirect_to user_context_path(@private_page_user.username, @article.slug)
        else
          flash.now.alert = "修改失敗"
          render :edit
        end
      end
    end
  end

  def destroy
    if @public_page_user.nil?
      # 網址資料錯誤
      redirect_to root_path
    else
      # 已登入
      if @public_page_user.id != session[:user_id]
        # 登入訪問別人
        # 這篇文章不是你的
        redirect_to root_path
      elsif @public_page_user.id == session[:user_id]
        # 登入訪問自己
        @public_page_user = nil
        @article = Article.friendly.find_by_user_id_and_slug(session[:user_id], params[:id])
        @article.destroy if @article
        redirect_to user_contexts_path(@private_page_user.username), :notice => "刪除成功"
      end
    end
  end

  private
  def context_params
      params.require(:article).permit(:title, :author, :tag, :image, :context )
  end

  def is_public_private
    @public_page_user = User.find_by_username(params[:user_id])
    @private_page_user = User.find_by_id(session[:user_id])
    if @public_page_user.present?
      @common＿lock = @public_page_user
    else
      @common＿lock = @private_page_user
    end
  end

end
