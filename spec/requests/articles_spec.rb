require 'spec_helper'

describe "Articles" do
  
  context "creating an article" do
    
    it "should allow a user to post an article" do
      make_account
      visit '/login'
      login
      
      visit '/articles/new'
      make_article
      page.should have_content("Article was successfully created")
      expected_path = "/articles/#{Article.count}"
      current_path.should == expected_path
    end
    
    it 'should redirect a visitor to login screen if there is a create attempt' do
      make_account
      visit '/logout'
      visit '/articles/new'
      current_path.should == '/login'
      login
      current_path.should == '/articles/new'
      make_article
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