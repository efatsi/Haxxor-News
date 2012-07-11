class Search
  
  attr_reader :params
  
  def initialize(params = {})
    @params = params
  end
  
  def results
    articles = Article.all

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
    
    articles
  end
  
end