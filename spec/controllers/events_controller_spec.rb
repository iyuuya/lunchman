require 'rails_helper'

describe "event_create" do
  let(:event) { FactoryGirl.build(:event) }

  include_context "setup_OmniAuth_config", :google_oauth2

  before :each do
    visit user_omniauth_authorize_path( provider: :google_oauth2 )

    visit new_event_path

    fill_in 'event[name]',             with: event.name

    fill_in 'event[event_at_date]',    with: event.event_at.strftime("%Y年%m月%d日")
    fill_in 'event[event_at_time]',    with: event.event_at.strftime("%H:%M %p")

    fill_in 'event[deadline_at_date]', with: event.event_at.strftime("%Y年%m月%d日")
    fill_in 'event[deadline_at_time]', with: event.event_at.strftime("%H:%M %p")

    fill_in 'event[comment]',          with: event.comment
    fill_in 'event[max_paticipants]',  with: event.max_paticipants
  end

  context "fill_in form" do
    it 'increse event count' do
      expect{ click_button I18n.t('layouts.event_new_label') }.to change( Event, :count ).by(1)
    end
  end

  context "fill_in form" do
    before do
      click_button I18n.t('layouts.event_new_label')
    end

    it 'redirect to events#index 'do
      expect( page.current_path ).to eq events_path
    end

    it 'no error classes in css' do
      expect( page ).not_to have_css('div.alert-danger')
    end
  end
end
