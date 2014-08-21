shared_context "fill_in_event_new_form" do |options={}|
  is_click_button = options[:is_click_button]

  let(:event) { FactoryGirl.build(:event) }

  service  = :google_oauth2
  include_context "setup_OmniAuth_config", service

  before do
    visit user_omniauth_authorize_path( provider: 'google_oauth2')

    visit new_event_path

    fill_in 'event[name]',             with: event.name

    fill_in 'event[event_at_date]',    with: event.event_at.strftime("%Y年%m月%d日")
    fill_in 'event[event_at_time]',    with: event.event_at.strftime("%H:%M %p")

    fill_in 'event[deadline_at_date]', with: event.event_at.strftime("%Y年%m月%d日")
    fill_in 'event[deadline_at_time]', with: event.event_at.strftime("%H:%M %p")

    fill_in 'event[comment]',          with: event.comment
    fill_in 'event[max_paticipants]',  with: event.max_paticipants

    click_button I18n.t('layouts.event_new_label') if is_click_button

  end

end
