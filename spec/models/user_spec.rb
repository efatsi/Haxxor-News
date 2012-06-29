require 'spec_helper'

describe User do
  
  before :all do
    @alpha = User.create(:username => "alpha_member", :password => "secret", :password_confirmation => "secret", :role => "admin")
    @beta = User.new(:username => "alpha_member", :password => "secret", :password_confirmation => "secret", :role => "member")
    @gamma = User.new(:username => "member2", :password => "secret", :password_confirmation => "notasecret", :role => "member")
    @delta = User.create(:username => "member3", :password => "secret", :password_confirmation => "secret", :role => "member")
    @google = Article.create(:link => "http://www.google.com", :title => "Google, Fake Article", :user_id => @alpha.id)
    @c1 = Comment.create(:content => "1st Comment", :commentable_type => "Article", :commentable_id => @google.id, :user_id => @alpha.id)
    @article_vote = Vote.create(:direction => "up", :votable_type => "Article", :votable_id => @google.id, :user_id => @alpha.id)
    @comment_vote = Vote.create(:direction => "up", :votable_type => "Comment", :votable_id => @c1.id, :user_id => @alpha.id)
  end
  
  after do
    @alpha.destroy
    @beta.destroy
    @gamma.destroy
    @delta.destroy
    @google.destroy
    @c1.destroy
    @article_vote.destroy
    @comment_vote.destroy
  end
  
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
    should_not allow_value("alpha_member").for(:username)
    
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
    @alpha.username.should == "alpha_member"
    @alpha.role.should == "admin"
  end
  
  it "should not allow repeat username" do
    @beta.save.should == false
  end
  
  it "should not allow different password and confirmation" do
    @gamma.save.should == false
  end

  it "should authenticate a user" do
    User.authenticate("alpha_member", "secret").should == @alpha
    @alpha.authenticate("secret").should == @alpha
  end
  
  it "should be able to get role of user" do
    @alpha.role?(:admin).should == true
  end
  
  
end
