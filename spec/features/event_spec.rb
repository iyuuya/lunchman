require 'rails_helper'

describe 'event_show', type: :feature do
  include_context 'setup_OmniAuth_config', :google_oauth2
  before do
    visit user_omniauth_authorize_path(provider: :google_oauth2)
  end

  describe 'creating new event', js: true do
    let!(:event) { FactoryGirl.build(:event) }

    before do
      visit events_path
      click_link I18n.t('layouts.link_to_event_new_top')
      page.execute_script("$('.bootstraptimepicker_date').removeAttr('readonly')")
      page.execute_script("$('.bootstraptimepicker_time').removeAttr('readonly')")
      fill_in 'event[name]',              with: event.name
      fill_in 'event[comment]',           with: event.comment
      fill_in 'event[event_at_date]',     with: event.event_at.strftime(I18n.t('date.formats.long'))
      fill_in 'event[event_at_time]',     with: event.event_at.strftime(I18n.t('time.formats.short'))
      fill_in 'event[deadline_at_date]',  with: event.deadline_at.strftime(I18n.t('date.formats.long'))
      fill_in 'event[deadline_at_time]',  with: event.deadline_at.strftime(I18n.t('time.formats.short'))
      fill_in 'event[max_participants]',  with: event.max_participants
    end

    describe 'when event created' do
      it 'Event count is increased by 1' do
        expect { click_button I18n.t('layouts.event_new_label') }.to change(Event, :count).from(0).to(1)
      end
    end

    describe 'successes to creating new event' do
      before do
        click_button I18n.t('layouts.event_new_label')
      end

      it 'redirect to events#index 'do
        expect(page.current_path).to eq events_path
      end
      it 'page has no error' do
        expect(page).not_to have_css('div.alert-danger')
      end
      it 'content has event name' do
        expect(page).to have_content event.name
      end
      it 'content has leader user' do
        expect(page).to have_content event.leader_user.name
      end
    end
  end

  describe 'visiting created event detail page' do
    let!(:event) { FactoryGirl.create(:event) }

    before do
      visit events_path
      click_link event.name
    end

    it 'content has layouts.event_show_top'do
      expect(page).to have_content I18n.t('layouts.event_show_top')
    end
    it 'content has event name' do
      expect(page).to have_content event.name
    end
  end

  describe 'editing created event' do
    let!(:event) { FactoryGirl.create(:event) }
    let!(:new_event_name) { 'new event name!' }

    context 'visiting edit form' do
      before do
        visit event_path(event)
        click_link I18n.t('layouts.event_edit')
        fill_in 'event[name]', with: new_event_name
        click_button I18n.t('layouts.event_edit_label')
      end

      subject { Event.find(event).name }
      it 'event name should change to new name' do
        is_expected.to eq(new_event_name)
      end
    end
  end
end
