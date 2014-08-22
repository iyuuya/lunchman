shared_context "setup_OmniAuth_config" do |service|
    before do
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
        provider: service.to_s,
        uid:      '111853197015656344117'#rtomita@aiming-inc.com
      })

      OmniAuth.config.add_mock(service,
        { info: {
            email: "rtomita@aiming-inc.com",
            name: "富田理央"
            },
          extra: {
            raw_info: {
              name: "富田理央"
            }
          }
        }
      )
    end

    let(:oauth_user){ OmniAuth.config.mock_auth[service] }
end
