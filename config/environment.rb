# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HaxxorNews::Application.initialize!


Time::DATE_FORMATS[:mdy] = "%b %d, %Y"
Time::DATE_FORMATS[:mdyt] = "%b %d, %Y at %H:%M"

Rails.logger = Logger.new(STDOUT)