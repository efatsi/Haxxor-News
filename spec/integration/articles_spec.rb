require 'spec_helper'

describe "Articles" do
  
  describe "creating an article" do
    
    it "should allow a user to post an article" do   
      make_account   
      click_link "submit"
      
      fill_in 'Title', :with => 'Example Page'
      fill_in 'Link', :with => 'example.com'
      
      expect { click_on 'Create Article' }.to change { Article.count }.by(1)
      page.should have_content("Article was successfully created")
      this_article_id = Article.last.id
      current_path.should == "/articles/#{this_article_id}"
    end
    
    it 'should redirect a visitor to login screen if there is a create attempt' do
      visit '/articles/new'
      current_path.should == '/login'
    end
    
    it "redirects the user to the new article form after login" do
      make_account
      click_on "Logout"
      visit '/articles/new'
      login
      current_path.should == '/articles/new'
    end
     
  end
  
  describe "viewing an article" do
    let!(:article_1) { FactoryGirl.create(:article, :title => 'Article #1') }
    let!(:article_2) { FactoryGirl.create(:article, :title => 'Article #2') }
    
    before { visit '/' }

    context "as a guest" do
      it "should allow me to view the index" do
        page.should have_content "Article #1"
        page.should have_content "Article #2"
        page.should have_button "Search"
      end

      it "should allow me to view a single article" do
        click_on_article("Article #1")
        
        find('h4').should have_content 'Article #1'
        page.should_not have_content "Article #2"
        page.should_not have_button "Search"
      end
    end
    
    context "as a registered user" do
      
      before { make_account }
      
      it "should allow me to view the index" do
        page.should have_content "Article #1"
        page.should have_content "Article #2"
        page.should have_button "Search"
      end

      it "should allow me to view a single article" do
        click_on_article("Article #2")
        
        find('h4').should have_content 'Article #2'
        page.should_not have_content "Article #1"
        page.should_not have_button "Search"
      end
      
    end
  end
  
  describe "editing/deleting restrictions" do
    
    before do
      article_1 = FactoryGirl.create(:article, :title => 'Article #1')
      make_account
      click_on "submit"
      make_article
    end
    
    it "should be able to edit your own article" do
      click_link "edit"
      fill_in 'Title', :with => 'Edited Article #1'
      fill_in 'Link', :with => 'editedexample.com'
      click_button "Update Article"
      current_path.should == "/articles/#{Article.last.id}"
      page.should have_content "Edited Article #1"
      page.should have_content "Article was successfully updated"
    end
    
    it "should be able to delete your own article" do
      expect { click_link "delete" }.to change { Article.count }.by(-1)
      current_path.should == "/articles"
      page.should have_content "Article was successfully deleted"      
    end
    
    it "should not let you edit another user's article" do
      visit '/articles'
      click_on_article("Article #1")
      page.should_not have_link "edit"
      expect { visit current_path + "/edit" }.to change { current_path }.from(current_path).to('/articles')
      page.should have_content "You cannot go here"   
    end

    it "should not let you delete another user's article" do
      visit '/'    
      click_on_article("Article #1")
      page.should_not have_link "delete"
    end
  end
  
  def make_article
    fill_in 'Title', :with => 'Example Page'
    fill_in 'Link', :with => 'example.com'
    click_on 'Create Article'
  end
  
  def click_on_article(article_name)
    article_node = all('table tbody tr td').detect {|n| n.text.include?(article_name) }
    article_node.click_link '0 comments'
  end
end