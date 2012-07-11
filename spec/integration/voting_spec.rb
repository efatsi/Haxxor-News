require 'spec_helper'

describe "Voting" do

  before :all do
    Article.delete_all
  end

  let!(:voting_user) { FactoryGirl.create(:user, :username => "voting_user", :password => "password", :password_confirmation => "password") }
  let!(:other_user) { FactoryGirl.create(:user, :username => "other_user", :password => "password", :password_confirmation => "password") }
  let!(:article_1) { FactoryGirl.create(:article, :title => 'Article #1', :user_id => voting_user.id) }
  let!(:comment_1) { FactoryGirl.create(:comment, :content => 'Comment #1', :commentable_type => "Article", :commentable_id => article_1.id, :user_id => voting_user.id) }

  context "voting on things" do

    before do
      visit '/login'
      login_with("voting_user", "password")
      visit '/'
    end

    it "should allow a user to upvote an article" do
      upvote_an_article("Article #1")      
      page.should_not have_button('^')
      page.should have_content('1 point by')
    end

    it "should allow a user to downvote an article" do
      downvote_an_article("Article #1")
      page.should_not have_button('^')
      page.should have_content('-1 points by')
    end
    
    it 'should allow a user to vote on a comment' do
      click_on_article("Article #1", "1 comment")
      click_on_comment("Comment #1")
      upvote_a_comment("Comment #1")
      page.should_not have_button('^')
    end

    it "should not allow a guest to vote on an article" do
      click_on "Logout"
      page.should_not have_button('^')
    end

    it "should not allow a guest to vote on a comment" do
      click_on "Logout"
      click_on_article("Article #1", "1 comment")
      click_on_comment("Comment #1")
      page.should_not have_button('^')
    end
    
  end
  
  context "seeing upvoted things" do
    
    before do
      # have voting_user vote on an article and a comment, direct to root
      visit '/login'
      login_with("voting_user", "password")
      click_on_article("Article #1", "1 comment")
      upvote_an_article("Article #1")
      upvote_a_comment("Comment #1")
      visit '/'
    end

    it "should see upvoted articles and comments for yourself" do
      click_on 'voting_user'
      click_on 'Upvoted'
      page.should have_content "Article #1"
      page.should have_content "Comment #1"
    end

    it "should see upvoted articles and comments for another user" do
      visit '/login'
      login_with("other_user", "password")
      click_on 'voting_user'
      click_on 'Upvoted'
      page.should have_content "Article #1"
      page.should have_content "Comment #1"
    end

    it "guest should see upvoted articles and comments for a user" do
      click_on 'Logout'
      click_on 'voting_user'
      click_on 'Upvoted'
      page.should have_content "Article #1"
      page.should have_content "Comment #1"
    end
    
  end
     
  
  def upvote_an_article(article_name)
    article_node = all('div article').detect {|n| n.text.include?(article_name) }
    article_node.click_on '^'
  end

  def downvote_an_article(article_name)
    article_node = all('div article').detect {|n| n.text.include?(article_name) }
    article_node.click_on 'v'
  end
  
  def upvote_a_comment(content)
    comment_node = all('div comment').detect {|n| n.text.include?(content) }
    comment_node.click_on '^'
  end
  
end