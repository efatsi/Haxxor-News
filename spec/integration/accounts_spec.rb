require 'spec_helper'

describe "Accounts" do
  
  context "on the sign-up page" do
    before { visit '/signup' }
    it "does not have an error" do
      page.should_not have_content('You cannot go here')
    end
    it "creates an account" do
      fill_in 'Username', :with => 'username'
      fill_in 'Password', :with => 'secret'
      fill_in 'Password confirmation', :with => 'secret' 
    
      expect { click_on 'Sign up' }.to change { User.count }.by(1)
    
      page.should have_content("User was successfully created")
      current_path.should == '/articles'
    end
  end
  
  context "logging in and out" do
    before {
      make_account
      login
    }
    
    it "should be at the root page" do
      current_path.should == '/articles'
      page.has_xpath?("Welcome")
    end
    
    it "should allow users to see the Welcome page" do
      click_link "welcome"
      current_path.should == '/welcome'
    end
    
    it 'should be able to logout' do
      visit '/logout'
      current_path.should == '/articles'
    end

    it "should not allow visitors to see the Welcome page" do
      visit '/logout'
      visit '/welcome'
      current_path.should == '/'
      page.should have_content("You cannot go here")
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
    visit '/login'
    fill_in 'Username', :with => 'username'
    fill_in 'Password', :with => 'secret'
    click_button 'Log In'
  end
  
end