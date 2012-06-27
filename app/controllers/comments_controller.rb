class CommentsController < ApplicationController

  include HaxxorNews::Voting
  
  before_filter :assign_commentable, :only => [:index, :create, :edit]
  skip_before_filter :store_location, :except => [:show]

  
  load_and_authorize_resource
  
  def index
    if @commentable.nil?
      @comments = Comment.all
    else
      @comments = @commentable.comments.rev_chronological
    end
  end
  
  def edit
  end
  
  def show
    @commentable = @comment
    @comments = @commentable.comments.rev_chronological
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
  
  def update
    if @comment.update_attributes(params[:comment])
      redirect_back_or_default(@comment)
    else
      render :edit
    end
  end
  
  # open this up to users who made them eventually
  def destroy
    @comment.destroy
    redirect_to :back
  end
  
  private
  
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
