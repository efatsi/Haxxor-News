require 'spec_helper'

describe "Accounts" do
  
  context "on the sign-up page" do
    before do
      visit '/'
      click_link 'Signup'
    end
    
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
    before do
      FactoryGirl.create(:user, :username => 'user', :password => 'password', :password_confirmation => 'password')
      visit '/login'
      login_with('user', 'password')
    end
    
    it "should be at the root page" do
      current_path.should == '/articles'
      page.should have_link("welcome")
    end
    
    it "should allow users to see the Welcome page" do
      click_link "welcome"
      current_path.should == '/welcome'
    end
    
    it 'should be able to logout' do
      click_link 'Logout'
      current_path.should == '/articles'
    end

    it "should not allow visitors to see the Welcome page" do
      click_link 'Logout'

      visit '/welcome'
      current_path.should == '/articles'
      
      page.should have_content("You cannot go here")
    end
  end
  
end