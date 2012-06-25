require 'spec_helper'

describe "Voting" do
  
  context "voting on an article" do
    
    it "should allow a user to vote on an article" do
      make_account
      visit '/login'
      login
      
      visit '/articles/new'
      make_article
      page.should have_content('0 points by')
      click_on '^'
      page.should_not have_button('^')
      page.should have_content('1 point by')
    end
    
    it "should not allow a guest to vote" do
      make_account
      visit '/login'
      login
      
      visit '/articles/new'
      make_article
      article_path = current_path
      visit '/'
      page.should have_button('^')
      click_on 'Logout'
      page.should_not have_button('^')
      visit article_path
      page.should_not have_button('^')
    end
     
  end  
  
  def make_account
    visit '/signup'
    fill_in 'Username', :with => 'username'
    fill_in 'Password', :with => 'secret'
    fill_in 'Password confirmation', :with => 'secret'
    click_on 'Sign up'
  end
  
  def login
    fill_in 'Username', :with => 'username'
    fill_in 'Password', :with => 'secret'
    click_button 'Log In'
  end
  
  def make_article
    fill_in 'Title', :with => 'Example Page'
    fill_in 'Link', :with => 'example.com'
    expect { click_on 'Create Article' }.to change { Article.count }.by(1)
  end
end