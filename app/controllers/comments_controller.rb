class CommentsController < ApplicationController
  
  before_filter :assign_comment, :only => [:show, :destroy]
  before_filter :assign_commentable, :only => [:index, :create]

  
  load_and_authorize_resource
  
  def index
    if @commentable.nil?
      @comments = Comment.all
    else  
      @comments = @commentable.comments
    end
  end
  
  def show
    @comments = @comment.comments
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
  
  def upvote
  	@comment.points += 1
  	@comment.save
  	redirect_to :back
  end
  
  def downvote
  	@comment.points -= 1
  	@comment.save
  	redirect_to :back
  end
  
  private
  def assign_comment
    @comment = Comment.find(params[:id])
  end
  
  def assign_commentable
    @commentable = find_commentable
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
