require 'rails_helper'

# cf http://easyramble.com/request-spec-for-devise-omniatuh.html
describe "Omniauth pages" do

  subject { page }

  describe 'with google oauth' do

    context "valid oauth signin when google email doesn't exist" do

      let(:oauth_user) { set_omniauth(:google_oauth2) }

      before do
        login_with_omniauth(oauth_user.provider)
      end
      let(:identity) { Identity.where(:provider => oauth_user.provider, :uid => oauth_user.uid).first }

      expect(identity).not_to eq nil
      expect(identity.provider).to eq oauth_user.provider
      expect(identity.uid).to eq oauth_user.uid
      expect(identity.name).to eq oauth_user.extra.raw_info.name


    end
  end
end
