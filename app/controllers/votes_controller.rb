class VotesController < ApplicationController
  
  before_filter :require_user, :only => :create

  def index
    @user = User.find(params[:user_id])
    @articles = Article.upvoted_by(@user).paginate(:page => params[:page])
    @comments = Comment.upvoted_by(@user)    
  end
  
  def create
    @votable = find_parent_resource
    @votable.create_vote_by(current_user, params[:direction])
    respond_to do |format|
      format.json
      format.html {
        redirect :back
      }
    end
  end

end