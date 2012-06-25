require 'spec_helper'

describe User do
  
  alpha = User.create(:username => "user_member", :password => "secret", :password_confirmation => "secret", :role => "admin")
  
  it "should validate a bunch of stuff" do
    
    should validate_presence_of(:username)
    should validate_presence_of(:password)
    should validate_presence_of(:password_confirmation)
    should validate_presence_of(:role)
    should validate_uniqueness_of(:username)
    
    should have_many(:articles)
    should have_many(:comments)
    should have_many(:votes)
    
    should allow_value("member2").for(:username)
    should_not allow_value(nil).for(:username)
    should_not allow_value("user_member").for(:username)
    
    should allow_value("secret").for(:password)
    should_not allow_value(nil).for(:password)
    
    should allow_value("secret").for(:password_confirmation)
    should_not allow_value(nil).for(:password_confirmation)
    
    should allow_value("member").for(:role)
    should allow_value("admin").for(:role)
    should_not allow_value(nil).for(:role)
    should_not allow_value("fake_role").for(:role)
  end  
  
  it "shows the user's attributes" do
    assert_equal alpha.username, "user_member"
    assert_equal alpha.role, "admin"
  end
  
  it "should not allow repeat username" do
    beta = User.new(:username => "user_member", :password => "secret", :password_confirmation => "secret", :role => "member")
    assert !beta.save, "Repeat username"
  end
  
  it "should not allow different password and confirmation" do
    gamma = User.new(:username => "member2", :password => "secret", :password_confirmation => "notasecret", :role => "member")
    assert !gamma.save, "Confirmation of password doesn't match"
  end

    it "should authenticate a user" do
      assert User.authenticate("user_member", "secret")
      assert alpha.authenticate("secret")
    end
  
  it "should be able to get role of user" do
    assert alpha.role?(:admin)
  end
  
  it "should know if you've voted on something or not" do
    delta = User.create(:username => "member3", :password => "secret", :password_confirmation => "secret", :role => "member")
    
    google = Article.create(:link => "http://www.google.com", :title => "Google, Fake Article", :user_id => alpha.id)
    c1 = Comment.create(:content => "1st Comment", :commentable_type => "Article", :commentable_id => google.id, :user_id => alpha.id)
    article_vote = Vote.create(:direction => "up", :votable_type => "Article", :votable_id => google.id, :user_id => alpha.id)
    comment_vote = Vote.create(:direction => "up", :votable_type => "Comment", :votable_id => c1.id, :user_id => alpha.id)
    
    assert_equal alpha.voted_on(google), true
    assert_equal alpha.voted_on(c1), true
    assert_equal delta.voted_on(google), false
    assert_equal delta.voted_on(c1), false
  end
  
end
