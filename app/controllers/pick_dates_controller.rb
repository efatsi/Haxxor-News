class PickDatesController < ApplicationController

  def new
    @pick_date = PickDate.new
  end
  
  def create
    selection = params[:pick_date]
    @pick_date = PickDate.new(selection)
    year = (selection[:year].blank? ? Time.now.year : selection[:year] )
    month = (selection[:month].blank? ? Time.now.month : selection[:month] )
    day = (selection[:day].blank? ? Time.now.day : selection[:day] )

    if request.post?
      case @pick_date.parser
      when :in_the_future  
        redirect_to pick_date_path, :alert => "You must select a time the past"      
      when :day  
        redirect_to articles_path(:day => day, :month => month, :year => year)      
      when :month  
        redirect_to articles_path(:month => month, :year => year)      
      when :year  
        redirect_to articles_path(:year => year)      
      else
        redirect_to articles_path, :alert => "You didn't pick anything"
      end
    end
  end

end
