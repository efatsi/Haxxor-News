class CommentsController < ApplicationController

  include HaxxorNews::Voting
  
  # before_filter :assign_comment, :only => [:show, :destroy]
  before_filter :assign_commentable, :only => [:index, :create]
  before_filter :assign_comment_collection, :only => [:index, :show]

  
  load_and_authorize_resource
  
  def index
    @comments = Comment.all if @commentable.nil?
  end
  
  def show
    @commentable = @comment
  end
  
  def create
    @comment = @commentable.comments.build(params[:comment].merge(:user_id => current_user.id))
    if @comment.save
      parent = @comment.commentable
      parent.update_count
      redirect_to :back
    else
      render :action => 'new'
    end
  end
  
  # open this up to users who made them eventually
  def destroy
    @comment.destroy
    redirect_to comments_url
  end
  
  private
  def assign_comment
    @comment = Comment.find(params[:id])
  end
  
  def assign_commentable
    @commentable = find_commentable
  end
  
  def assign_comment_collection
    @comments = @commentable.comments.rev_chronological
  end
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end  
  
end
