shared_context "setup_OmniAuth_config" do |service|
  before do
    OmniAuth.config.test_mode = true

    oauthinfo = {
      uid:    Faker::Number.number(21),
      name:   Faker::Name.name,
      email:  Faker::Internet.slug + Faker::Internet.free_email
    }
    OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new(
      {
        provider:   service.to_s,
        uid:        oauthinfo[:uid],
        info: {
          email:    oauthinfo[:email],
          name:     oauthinfo[:name]
        },
        extra: {
          raw_info: {
            name:    oauthinfo[:name]
          }
        }
      }
    )
  end

  let(:oauth_user) { OmniAuth.config.mock_auth[service] }
end
