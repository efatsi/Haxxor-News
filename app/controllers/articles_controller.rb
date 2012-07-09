class ArticlesController < ApplicationController
  
  include HaxxorNews::Voting
  
  before_filter :assign_article, :only => [:show, :edit, :update, :destroy]
  before_filter :require_user, :only => [:new, :edit]

  load_and_authorize_resource

  def index
    
    if params[:by_rating]
      articles = Article.by_rating 
    else
      articles = Article.chronological
    end      
    
    if params[:by_user]
      articles = articles.by_user(params[:by_user])
    end 

    if params[:this_day]  
      articles = articles.this_day
    elsif params[:this_month]  
      articles = articles.this_month
    elsif params[:this_year]  
      articles = articles.this_year
    end
    
    if params[:day]  
      articles = articles.day(params[:day].to_i, params[:month], params[:year])
    elsif params[:month]  
      articles = articles.month(params[:month].to_i, params[:year])
    elsif params[:year]  
      articles = articles.year(params[:year].to_i)
    end
    
    @articles = articles.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
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
    # Fill in blanks if any exist (won't affect scope chosen in later if/else section)
    year = ( params[:year].blank? ? Time.now.year : params[:year] )
    month = ( params[:month].blank? ? Time.now.month : params[:month] )
    day = ( params[:day].blank? ? Time.now.day : params[:day] )
  
    if request.post?
      if Time.local(year, month, day) > Time.now
        redirect_to pick_date_path, :alert => "You must select a time the past"
      elsif params[:day].present?
        redirect_to root_url(:day => day, :month => month, :year => year)
      elsif params[:month].present?
        redirect_to root_url(:month => month, :year => year)
      elsif params[:year].present?
        redirect_to root_url(:year => year)
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
