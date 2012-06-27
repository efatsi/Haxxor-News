class ArticlesController < ApplicationController
  
  include HaxxorNews::Voting
  
  before_filter :require_user, :only => [:new]
  skip_before_filter :store_location, :except => [:index, :show, :new]
  
  load_and_authorize_resource

  def index
  	@articles = Article.chronological.search(params[:search], params[:page])
  end

  def show
    @comments = @article.comments.rev_chronological
    @commentable = @article
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = current_user.articles.build(params[:article])

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def update
    if @article.update_attributes(params[:article])
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully deleted.'
  end
  
end