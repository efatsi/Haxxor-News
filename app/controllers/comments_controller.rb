class CommentsController < ApplicationController

  include HaxxorNews::Voting
  
  before_filter :assign_commentable, :only => [:index, :create, :edit]
  skip_before_filter :store_location, :except => [:show]

  load_and_authorize_resource
  
  def index

    if @commentable.nil?
      if params[:by_user]
        @comments = Comment.by_user(params[:by_user]).chronological.paginate(:page => params[:page], :per_page => 10)
      else
        @comments = Comment.chronological.paginate(:page => params[:page], :per_page => 20)
      end
    else  
      @comments = @commentable.comments
    end
  end
  
  def edit
  end
  
  def show
    @commentable = @comment
    @comments = @commentable.comments.reverse_chronological
  end
  
  def create
    @comment = @commentable.comments.build(params[:comment].merge(:user_id => current_user.id))
    if @comment.save
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
  
  def destroy
    parent = @comment.commentable
    @comment.destroy
    redirect_to parent
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
