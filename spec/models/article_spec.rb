require 'spec_helper'

describe Article do
  
  before :all do
    @alpha = User.create(:username => "member", :password => "secret", :password_confirmation => "secret", :role => "admin")
    @google = Article.create(:link => "http://www.google.com", :title => "Google, Fake Article", :user_id => @alpha.id)
    @walmart = Article.new(:link => "walmart.com", :title => "Walmart", :user_id => @alpha.id)
    @target = Article.new(:link => "www.target.com", :title => "Target", :user_id => @alpha.id)
  end
  
  after :all do
    @alpha.destroy
    @google.destroy
    @walmart.destroy
    @target.destroy
  end
  
  it "should validate a bunch of stuff" do
    
    should validate_presence_of(:link)
    should validate_presence_of(:title)
    should validate_presence_of(:user_id)
    
    should belong_to(:user)
    should have_many(:comments)
    should have_many(:votes)
    
    should allow_value("github.com").for(:link)
    should allow_value("www.github.com").for(:link)
    should allow_value("http://www.github.com").for(:link)
    should_not allow_value(nil).for(:link)
    should_not allow_value("").for(:link)
    should_not allow_value("285").for(:link)
    should_not allow_value("string").for(:link)
    
    should allow_value("This is an Article").for(:title)
    should_not allow_value(nil).for(:title)
    
    should allow_value(1).for(:user_id)
    should_not allow_value(nil).for(:user_id)
  end  
  
  it "shows the article's attributes" do
    @google.save.should == true
    @google.link.should == "http://www.google.com"
    @google.title.should == "Google, Fake Article"
  end
  
  it "should add http:// to link if necessary" do
    @walmart.save.should == true
    @target.save.should == true
    @walmart.link.should == "http://walmart.com"
    @target.link.should == "http://www.target.com"
  end
  
  it "should show the short link" do
    @google.short_link.should == "google.com"
  end
  
  it "should increase the count by 1" do
    expect { @google.update_count(1) }.to change{ @google.comment_count }.by(1)
  end
  
  it "should decrease the count by 1" do
    expect { @google.update_count(-1) }.to change{ @google.comment_count }.by(-1)
  end
  
end
