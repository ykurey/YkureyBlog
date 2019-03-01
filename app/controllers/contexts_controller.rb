class ContextsController < ApplicationController
  # helper_method :tesa

  LIMIT_PAGE = 5

  def index
    puts "123"
    puts session[:user_id].present?
    puts "---"

    @re = Article.where(:user_id => session[:user_id])
    @re.each do |uu|
      puts uu.title
    end

    puts "---"
    # @c8 = Article.find_by_sql("select * from articles where user_id = '#{session[:user_id]}' ")
    # @c8.each do |oo|
    #   puts oo.title
    # end


    @articles = Article.all
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
    @article = Article.find_by(id: params[:id])
    @previous = Article.where("id < ?", params[:id]).order(:id).first
    @next = Article.where("id > ?", params[:id]).order(:id).first
  end

  private
  # def tesa
  #     @tesa ||= session[:user_id]
  # end
end
