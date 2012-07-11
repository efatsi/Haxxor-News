class PickDate

  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :year, :month, :day, :params
  
  def initialize(params = {})
    @params = params
  end

  def parser
    year = ( params[:year].blank? ? Time.now.year : params[:year] )
    month = ( params[:month].blank? ? Time.now.month : params[:month] )
    day = ( params[:day].blank? ? Time.now.day : params[:day] )
    if Time.local(year, month, day) > Time.now
      :in_the_future
    elsif params[:day].present?
      :day
    elsif params[:month].present?
      :month
    elsif params[:year].present?
      :year
    end
  end

  def persisted?
    params.present?
  end

end