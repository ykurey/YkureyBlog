class QuestionsController < ApplicationController

  def show
    @yy = User.find_by_email!(params[:user_id])
  end
end
