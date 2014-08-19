require 'rails_helper'

describe User do

  service  = :google_oauth2
  include_context "setup_OmniAuth_config", service

  describe "relationships" do
    it { should have_one :identity }
    it { should have_many :event }
  end

  describe "find_or_create_with_email" do

    context "when giving oauth user data " do

      it "should user.name is oauth_user.info.name " do
        user = User.find_or_create_with_email( oauth_user )
        expect( user.name ).to eq( oauth_user.info.name )
      end
    end
  end



  describe "get_email_from_auth" do

    context "when giving oauth user data " do

      it "should email is oauth_user.info.email " do
        email = User.get_email_from_auth( oauth_user )
        expect( email ).to eq( oauth_user.info.email )
      end
    end
  end

end
