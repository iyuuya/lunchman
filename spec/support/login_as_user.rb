shared_context 'login_as_user' do
  include_context 'setup_OmniAuth_config', :google_oauth2
  before { visit user_omniauth_authorize_path(provider: :google_oauth2) }
  let!(:login_user) { User.joins(:identity).where(identities: { uid: oauth_user.uid }).first }
end
