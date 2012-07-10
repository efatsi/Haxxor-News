require 'spec_helper'

describe PasswordReset do
  
  it { should validate_presence_of(:identifier) }
  
  describe "validations" do
    it "requires the presence of a user" do
      subject = described_class.new(:identifier => 'eli')
      subject.errors_on(:user).should == ['was not found']
    end
    
    it "requires that the matching user have an email address" do
      user    = FactoryGirl.create(:user, :username => 'eli', :email => nil)
      subject = described_class.new(:identifier => 'eli')
      
      subject.errors_on(:user).should == ['must have an email address']
    end
  end
  
  describe "attributes" do
    it "allows mass assignment" do
      subject = described_class.new(:identifier => 'foo')
      subject.identifier.should == 'foo'
    end
  end
  
  describe "#user" do
    it "is nil by default" do
      subject.user.should be_nil
    end
    
    it "returns the user with a matching username" do
      user = FactoryGirl.create(:user, :username => 'eli')
      subject = described_class.new(:identifier => 'eli')
      
      subject.user.should == user
    end
    
    it "returns the user with a matching email address" do
      user = FactoryGirl.create(:user, :email => 'eli@viget.com')
      subject = described_class.new(:identifier => 'eli@viget.com')
      
      subject.user.should == user
    end
  end
  
  describe "#save" do
    # * does nothing if the request is invalid
    # * generate the token for the user?
    # * sends an email to the user with instructions
    it "does not send an email if the request is invalid" do
      UserMailer.should_receive(:password_reset).never
      subject.save
    end
    
    it "returns false when the request is invalid" do
      subject.save.should be(false)
    end

    context "when the request is valid" do
      let!(:user)  { FactoryGirl.create(:user, :username => 'eli', :email => 'eli@viget.com', :password_reset_token => nil) }
      let(:mailer) { double('password reset mailer') }
      
      subject      { described_class.new(:identifier => 'eli') }

      it "generates a token for the user" do
        expect { subject.save }.to change { user.reload.password_reset_token }.from(nil)
      end

      it "sends an email" do
        mailer.should_receive(:deliver)
        UserMailer.stub(:password_reset).with(user).and_return(mailer)

        subject.save
      end

      it "returns true when successful" do
        mailer.stub(:deliver)
        UserMailer.stub(:password_reset).with(user).and_return(mailer)

        subject.save.should be(true)
      end
      
      it "saves the password_reset_sent_at time" do
        subject.save
        user.reload.password_reset_sent_at.should_not be_nil
      end
    end
    
  end
  
end