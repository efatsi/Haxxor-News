class CommentsController < ApplicationController
  
  before_filter :assign_comment, :only => [:show, :destroy]
  def assign_comment
    @comment = Comment.find(params[:id])
  end
  
  load_and_authorize_resource
  
  def index
    @commentable = find_commentable
    if !@commentable.nil?
      @comments = @commentable.comments 
    else
      @comments = Comment.all
    end
  end
  
  def show
    @comments = @comment.comments
    @commentable = @comment
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment].merge(:user_id => current_user.id))
    if @comment.save
      # flash[:notice] = "Successfully created comment."
      commenting_on = @comment.commentable_type.pluralize
      id = @comment.commentable_id
      eval "redirect_to #{@comment.commentable_type.downcase}_path(:id=>#{id})"
    else
      render :action => 'new'
    end
  end
  
  # open this up to users who made them  
  def destroy
    @comment.destroy
    # flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_url
  end
  
  private
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end  
  
end
