class ArticlesController < ApplicationController
  
  before_filter :require_user, :only => [:new, :edit]

  load_and_authorize_resource

  def index
    @articles = Search.new(params).results    
    @articles = @articles.search(params[:search], params[:page])
  end

  def show
    @comments = @article.comments.reverse_chronological
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
  
  def pick_date
    year = ( params[:year].blank? ? Time.now.year : params[:year] )
    month = ( params[:month].blank? ? Time.now.month : params[:month] )
    day = ( params[:day].blank? ? Time.now.day : params[:day] )
  
    if request.post?
      if Time.local(year, month, day) > Time.now
        redirect_to pick_date_path, :alert => "You must select a time the past"
      elsif params[:day].present?
        redirect_to articles_path(:day => day, :month => month, :year => year)
      elsif params[:month].present?
        redirect_to articles_path(:month => month, :year => year)
      elsif params[:year].present?
        redirect_to articles_path(:year => year)
      else
        redirect_to root_url
      end
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
