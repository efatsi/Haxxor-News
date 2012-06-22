require 'spec_helper'

describe "Comments" do
  
  context "creating a comment" do
    
    it "should allow a user to create a comment" do
      make_article
      expect { make_comment }.to_not change { current_path }
    end
    
    it 'should prompt login, then allow user to create a comment' do
      make_article
      article_path = current_path
      visit '/logout'
      visit article_path
      click_on "log in"
      login
      current_path.should == article_path
      expect { make_comment }.to_not change { current_path }
    end
    
    it "should allow users to comment on comments, and navigate around them" do
      make_article
      article_path = current_path
      make_comment
      click_link 'link'
      comment_path = current_path
      fill_in 'Content', :with => "This is a comment on a comment"
      expect { click_on 'Add Comment' }.to change { Comment.count }.by(1)
      page.should have_content("This is a comment on a comment")
      click_link 'link'
      new_comment_path = current_path
      expect { click_link 'parent' }.to change { current_path }.from(new_comment_path).to(comment_path)
      expect { click_link 'parent' }.to change { current_path }.from(comment_path).to(article_path)  
      page.should have_content("This is a primary")
      page.should have_content("This is a comment on a comment")  
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
    make_account
    visit '/login'
    login
    visit '/articles/new'
    fill_in 'Title', :with => 'Example Page'
    fill_in 'Link', :with => 'example.com'
    click_on 'Create Article'
  end
  
  def make_comment
    fill_in 'Content', :with => "This is a primary comment"
    expect { click_on 'Add Comment' }.to change { Comment.count }.by(1)
  end
end