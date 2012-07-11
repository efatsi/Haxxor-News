require 'spec_helper'

describe VotesController do
  context 'not logged in' do
    describe 'post #create upvote article' do
      let!(:article){ FactoryGirl.create(:article) }

      before do
        request.env["HTTP_REFERER"] = 'http://haxxor_news.test/articles'
        post :create, :article_id => article.id, :direction => "up"
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end
    
    describe 'get #index' do
      let!(:article){ FactoryGirl.create(:article) }
      let!(:user){ FactoryGirl.create(:user) }
      
      before do
        article.create_vote_by(user, "up")
        get :index, :user_id => user.id, :direction => 'up'
      end
      
      it { should respond_with(:success) }
      it { should render_template(:index) }
    end
  end

  context 'logged in' do
    let(:user){ FactoryGirl.create(:user) }

    before do
      login_as user
    end

    describe 'post #create upvote article' do
      let!(:article){ FactoryGirl.create(:article) }

      before do
        request.env["HTTP_REFERER"] = 'http://haxxor_news.test/articles'
        post :create, :article_id => article.id, :direction => "up"
      end

      it { should respond_with(:redirect) }
      it { should redirect_to('http://haxxor_news.test/articles') }

      it "should create a vote for that user on that article" do
        Article.upvoted_by(user).should include(article)
      end
    end

    describe 'post #create downvote article' do
      let!(:article){ FactoryGirl.create(:article) }

      before do
        request.env["HTTP_REFERER"] = 'http://haxxor_news.test/articles'
        post :create, :article_id => article.id, :direction => "down"
      end

      it { should respond_with(:redirect) }
      it { should redirect_to('http://haxxor_news.test/articles') }

      it "should create a vote for that user on that article" do
        Article.voted_on_by(user).where("votes.direction = 'down'").should include(article)
      end
    end
    
    describe 'post #create upvote comment' do
      let!(:comment){ FactoryGirl.create(:comment) }

      before do
        request.env["HTTP_REFERER"] = 'http://haxxor_news.test/articles'
        post :create, :comment_id => comment.id, :direction => "up"
      end

      it { should respond_with(:redirect) }
      it { should redirect_to('http://haxxor_news.test/articles') }

      it "should create a vote for that user on that comment" do
        Comment.upvoted_by(user).should include(comment)
      end
    end
    
    describe 'post #create downvote comment' do
      let!(:comment){ FactoryGirl.create(:comment) }

      before do
        request.env["HTTP_REFERER"] = 'http://haxxor_news.test/articles'
        post :create, :comment_id => comment.id, :direction => "down"
      end

      it { should respond_with(:redirect) }
      it { should redirect_to('http://haxxor_news.test/articles') }

      it "should create a vote for that user on that comment" do
        Comment.voted_on_by(user).where("votes.direction = 'down'").should include(comment)
      end
    end
  end
end