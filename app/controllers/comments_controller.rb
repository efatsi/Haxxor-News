class CommentsController < ApplicationController
  
  before_filter :assign_comment, :only => [:show, :edit, :update, :destroy]
  
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
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
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
  def edit
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      # flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  # open this up to users who made them  
  def destroy
    @comment.destroy
    # flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_url
  end
    
  def assign_comment
    @comment = Comment.find(params[:id])
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
