class ContextController < ApplicationController

  LIMIT_PAGE = 5
  
  def index
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

    @poii = []
    @articles.each do |article|
      @poii << [article.id, article.title]
    end
#        限制筆數
    @articles = @articles.offset( ((@page - 1) * LIMIT_PAGE) ).limit(LIMIT_PAGE)
  end

end
