require 'spec_helper'

describe Vote do
  
  before :all do
    @alpha = User.create(:username => "vote_member", :password => "secret", :password_confirmation => "secret", :role => "admin")
    @google = Article.create(:link => "http://www.google.com", :title => "Google, Fake Article", :user_id => @alpha.id)
    @c1 = Comment.create(:content => "1st Comment", :commentable_type => "Article", :commentable_id => @google.id, :user_id => @alpha.id)
    @article_vote = Vote.create(:direction => "up", :votable_type => "Article", :votable_id => @google.id, :user_id => @alpha.id)
    @comment_vote = Vote.create(:direction => "up", :votable_type => "Comment", :votable_id => @c1.id, :user_id => @alpha.id)
  end
  
  after :all do
    @alpha.destroy
    @google.destroy
    @c1.destroy
    @article_vote.destroy
    @comment_vote.destroy
  end
  
  it "should validate a bunch of stuff" do
    
    should validate_presence_of(:direction)
    should validate_presence_of(:user_id)
    should validate_presence_of(:votable_id)
    should validate_presence_of(:votable_type)
    
    should belong_to(:user)
    should belong_to(:votable)
    
    should allow_value("up").for(:direction)
    should allow_value("down").for(:direction)
    should_not allow_value(nil).for(:direction)
    should_not allow_value("middle").for(:direction)
    
    should allow_value(1).for(:user_id)
    should_not allow_value(nil).for(:user_id)
    
    should allow_value(1).for(:votable_id)
    should_not allow_value(nil).for(:votable_id)
    
    should allow_value("Article").for(:votable_type)
    should allow_value("Comment").for(:votable_type)
    should_not allow_value(nil).for(:votable_type)
  end  
  
  it "should be able to get the vote's attributes" do
    assert_equal @article_vote.direction, "up"
    assert_equal @comment_vote.votable_type, "Comment"
    assert_equal @article_vote.votable_id, @google.id
    assert_equal @comment_vote.user_id, @alpha.id
  end
  
  it "should be able to get the parent" do
    assert_equal @article_vote.votable, @google 
    assert_equal @comment_vote.votable, @c1
  end
  
  it "should know what votes exist or not" do
    Vote.contains?(@alpha, @google).should == true
    Vote.contains?(@alpha, @c1).should == true
  end
  
end
