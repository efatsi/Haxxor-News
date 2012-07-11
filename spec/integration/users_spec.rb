require "spec_helper"

describe "Users" do
  
  context "viewing user's upvoted resources" do
    let!(:user) { FactoryGirl.create(:user, :username => "gen_user") }
    let!(:article_by_user){ FactoryGirl.create(:article, :user => user) }
    let!(:article_upvoted){ FactoryGirl.create(:article, :title => "JimmyJohns") }
    let!(:article_downvoted){ FactoryGirl.create(:article, :title => "Github Get Funding") }
    let!(:comment){ FactoryGirl.create(:comment, :content => "JimmyRustler") }
    
    before do
      article_upvoted.create_vote_by(user, "up")
      comment.create_vote_by(user, "up")
      article_downvoted.create_vote_by(user, "down")
    end
    
    it "should allow guest to view upvoted resources" do
      visit '/'
      click_link "gen_user"
      click_link "Upvoted"
      page.should have_content("JimmyJohns")
      page.should have_content("JimmyRustler")
      page.should_not have_content("Github Get Funding")
    end
    
  end
  
end