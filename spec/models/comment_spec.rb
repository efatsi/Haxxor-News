require 'spec_helper'

describe Comment do
  
  before :all do
    @alpha = FactoryGirl.create(:user, :username => "comment_member", :password => "secret", :password_confirmation => "secret", :role => "admin")
    @google = Article.create(:link => "http://www.google.com", :title => "Google, Fake Article", :user_id => @alpha.id)
    @c1 = Comment.create(:content => "1st Comment", :commentable_type => "Article", :commentable_id => @google.id, :user_id => @alpha.id)
  end
  
  after :all do
    @alpha.destroy
    @google.destroy
    @c1.destroy
  end
  
  it "should validate a bunch of stuff" do
    
    should validate_presence_of(:content)
    should validate_presence_of(:user_id)
    should validate_presence_of(:commentable_id)
    should validate_presence_of(:commentable_type)
    
    should belong_to(:user)
    should belong_to(:commentable)
    should have_many(:comments)
    should have_many(:votes)
    
    should allow_value("This is a Comment!!!").for(:content)
    should_not allow_value(nil).for(:content)
    
    should allow_value(1).for(:user_id)
    should_not allow_value(nil).for(:user_id)
    
    should allow_value(1).for(:commentable_id)
    should_not allow_value(nil).for(:commentable_id)
    
    should allow_value("Article").for(:commentable_type)
    should allow_value("Comment").for(:commentable_type)
    should_not allow_value(nil).for(:commentable_type)
  end  
  
  it "should show the comment's attributes/parent" do
    @c1.content.should == "1st Comment"
    @c1.commentable_type.should == "Article"
    @c1.commentable_id.should == @google.id
    @c1.user_id.should == @alpha.id
    @c1.commentable.should == @google
  end

  it "should increase count of itself" do
    expect { @c1.update_count(1) }.to change{ @c1.comment_count }.by(1)
  end

  it "should increase the count of i's parent" do
    expect { @c1.update_count(1) }.to change{ @c1.commentable.comment_count }.by(1)
  end


  it "should decrease count of itself" do
    expect { @c1.update_count(-1) }.to change{ @c1.comment_count }.by(-1)
  end

  it "should decrease the count of i's parent" do
    expect { @c1.update_count(-1) }.to change{ @c1.commentable.comment_count }.by(-1)
  end
  
end
