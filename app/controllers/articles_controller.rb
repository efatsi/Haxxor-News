class ArticlesController < ApplicationController
  
  include HaxxorNews::Voting
  
  # before_filter :assign_article, :except => [:index, :new, :create]
  before_filter :require_user, :only => [:new]
  skip_before_filter :store_location, :except => [:index, :show, :new]
  

  load_and_authorize_resource

  def index
  	@articles = Article.chronological.search(params[:search], params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def show
    @comments = @article.comments.rev_chronological
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
  # def assign_article
  #   @article = Article.find(params[:id])
  # end
  
end
