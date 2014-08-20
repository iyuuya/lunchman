require 'rails_helper'

# cf http://easyramble.com/request-spec-for-devise-omniatuh.html
describe "event_create" do

  describe "login with google oauth" do
    let!(:event) { FactoryGirl.create(:event) }

    service  = :google_oauth2
    include_context "setup_OmniAuth_config", service

    before do
      # login
      visit "/users/auth/google_oauth2"

      # visit event create form
      visit "/events/new"
    end

    it 'increse event count' do
      expect{
        fill_in 'event[name]',             with: event.name

        fill_in 'event[event_at_date]',           with: event.event_at.strftime("%Y/%m/%d")
        fill_in 'event[event_at_time]',           with: event.event_at.strftime("%H:%M")

        fill_in 'event[deadline_at_date]',           with: event.event_at.strftime("%Y/%m/%d")
        fill_in 'event[deadline_at_time]',           with: event.event_at.strftime("%H:%M")

        fill_in 'event[comment]',          with: event.comment
        fill_in 'event[max_paticipants]',  with: event.max_paticipants

        click_button '作成'

        }.to change( Event, :count ).by(1)
    end


  end

end
