class ArticlesController < ApplicationController
  
  before_filter :assign_article, :only => [:show, :edit, :update, :destroy]
  before_filter :require_user, :except => [:index, :show]

  load_and_authorize_resource

  def index
    
    if params[:by_rating]
      articles = Article.by_rating 
    else
      articles = Article.chronological
    end      
    
    articles = articles.by_user(params[:by_user]) if params[:by_user]
    
    if params[:this_day]  
      articles = articles.this_day
    elsif params[:this_month]  
      articles = articles.this_month
    elsif params[:this_year]  
      articles = articles.this_year
    end
    
    @articles = articles.search(params[:search], params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def show
    @comments = @article.comments
    @commentable = @article
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  def new
    @article = Article.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  def edit
  end

  def create
    @article = current_user.articles.build(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
  
  private
  def assign_article
    @article = Article.find(params[:id])
  end
  
end
