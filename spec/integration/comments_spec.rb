require 'spec_helper'

describe "Comments" do
  
  let!(:article_1) { FactoryGirl.create(:article, :title => "Article #1") }
  let!(:comment_user) { FactoryGirl.create(:user, :username => 'comment_user', :password => 'password', :password_confirmation => 'password') }
  let!(:comment_1) { FactoryGirl.create(:comment, :content => "Article 1's Comment", :commentable_type => "Article", :commentable_id => article_1.id, :user_id => comment_user.id)}
  
  context "creating a comment" do
    
    before do
      comment_1.update_count
      visit '/login'
      login_with("comment_user", "password")
    end
    
    it "should allow a user to create a comment" do
      click_on_article("Article #1", "1 comment")            
      fill_in 'Content', :with => "This is a primary comment"
      expect { click_on 'Add Comment' }.to change { Comment.count }.by(1)
    end
    
    it 'should show login link for guest, then allow user to create a comment' do
      click_link "Logout"
      click_on_article("Article #1", "1 comment")
      article_1_path = current_path
      click_on "log in"
      login_with("comment_user", "password")
      current_path.should == article_1_path
      expect { make_comment }.to_not change { current_path }
    end
    
    it "should allow users to comment on comments" do
      click_on_article("Article #1", "1 comment")
      make_comment
      click_on_comment("This is a primary comment")
      fill_in 'Content', :with => "This is a comment on a comment"
      expect { click_on 'Add Comment' }.to change { Comment.count }.by(1)
      page.should have_content "This is a primary comment"
      page.should have_content "This is a comment on a comment"
    end
  end
  
  context "editing and deleting comments" do
    
    before do
      comment_1.update_count
      visit '/login'
      login_with("comment_user", "password")
    end
    
    it "should allow a user to edit their own comment" do
      visit comment_path(comment_1)
      click_link "edit"
      page.should have_content "Current content:"
      fill_in 'Content', :with => "This is Article 1's edited comment"
      expect { click_on 'Edit Comment' }.to_not change { Comment.count }
      page.should have_content "This is Article 1's edited comment"
    end
    
    it "should allow a user to delete their own comment" do
      
    end
    
    it "should not allow a non-owner to edit a comment" do
      
    end
    
    it "should not allow a non-owner to delete a comment" do
      
    end
    
  end
  
  context "navigating around comments" do
    
    let!(:comment_2) { FactoryGirl.create(:comment, :content => "Deep comment", :commentable_type => "Comment", :commentable_id => comment_1.id, :user_id => comment_user.id)}

    before do
      comment_1.update_count
      comment_2.update_count
      visit '/'
    end
    
    it "should allow users to navigate down comment chains" do
      click_link "Login"
      login_with("comment_user", "password")
      click_on_article("Article #1", "2 comments")
      current_path.should == article_path(article_1)
      click_on_comment("Article 1's Comment")
      current_path.should == comment_path(comment_1)
      click_on_comment("Deep comment")
      current_path.should == comment_path(comment_2)
    end
    
    it "should allow guests to navigate down comment chains" do
      click_on_article("Article #1", "2 comments")
      current_path.should == article_path(article_1)
      click_on_comment("Article 1's Comment")
      current_path.should == comment_path(comment_1)
      click_on_comment("Deep comment")
      current_path.should == comment_path(comment_2)
    end

    it "should allow users to navigate back up comment chains" do
      click_link "Login"
      login_with("comment_user", "password")
      visit comment_path(comment_2)
      click_link("parent")
      current_path.should == comment_path(comment_1)
      click_link("parent")
      current_path.should == article_path(article_1)
    end

    it "should allow guests to navigate back up comment chains" do
      visit comment_path(comment_2)
      click_link("parent")
      current_path.should == comment_path(comment_1)
      click_link("parent")
      current_path.should == article_path(article_1)
    end
    
  end  
  
  def click_on_article(article_name, link)
    article_node = all('table tbody tr td').detect {|n| n.text.include?(article_name) && n.text.include?(link)}
    article_node.click_link "#{link}"
  end
  
  def click_on_comment(context)
    comment_node = all('div comment').detect { |n| n.text.include?(context) }
    # raise comment_node.inspect
    comment_node.click_link "link"
  end
  
  def make_comment
    fill_in 'Content', :with => "This is a primary comment"
    click_on 'Add Comment'
  end
end