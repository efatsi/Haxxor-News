require 'spec_helper'

describe ArticlesController do
  
  def login_as(user)
    controller.stub(:current_user).and_return(user)
  end
  
  describe "A DELETE to :destroy" do
    it "does not delete the article when initiated by a guest" do
      article = FactoryGirl.create(:article)
      delete :destroy, :id => article.id

      Article.find_by_id(article.id).should_not be_nil
    end
    
    it "redirects when initiated by a user who is not the owner" do
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      
      article = FactoryGirl.create(:article, :user => user_1)
      
      login_as user_2
      
      delete :destroy, :id => article.id

      Article.find_by_id(article.id).should_not be_nil
    end
  end
  
end