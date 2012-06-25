# SimpleCov required here...
require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # ----------------------------------------------------
  # THIS HELPER METHOD IS NOT A DEFAULT METHOD IN RAILS
  # (added in by Prof. H; will have to include it if used in phase 2)
  def deny(condition)
    # a simple transformation to increase readability IMO
    assert !condition
  end
end
