require 'rails_helper'

describe 'event_show', type: :feature do
  let(:current_user) { User.joins(:identity).where(identities: { uid: oauth_user.uid }).first }

  include_context 'setup_OmniAuth_config', :google_oauth2
  before do
    visit user_omniauth_authorize_path(provider: :google_oauth2)
  end

  describe 'visiting event list page' do
    let!(:participant_user) { FactoryGirl.create :user }
    let!(:events) { FactoryGirl.create_list :event, 2, leader_user_id: current_user.id }
    before do
      FactoryGirl.create :participant, event_id: events.first.id, user_id: participant_user.id
      visit events_path
    end

    it 'should display participant amounts' do
      events.each do |event|
        expect(page).to have_content "#{event.participants.count} / #{event.max_participants} #{I18n.t('layouts.participant_unit')}"
      end
    end
  end

  describe 'creating new event', js: true do
    let!(:event) { FactoryGirl.build(:event, leader_user_id: current_user.id) }

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
        expect { click_button I18n.t('layouts.event_new_label') }.to change(Event, :count).by(1)
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

      it 'within leader event list, content should has event name' do
        within '#leader_event_list' do
          expect(page).to have_content event.name
        end
      end
    end
  end

  describe 'visiting created event detail page' do
    let!(:event) { FactoryGirl.create(:event, leader_user_id: current_user.id) }

    before do
      visit events_path
      within '#leader_event_list' do
        click_link event.name
      end
    end

    it 'content has layouts.event_show_top'do
      expect(page).to have_content I18n.t('layouts.event_show_top')
    end
    it 'content has event name' do
      expect(page).to have_content event.name
    end
  end

  describe 'editing created event' do
    let!(:event) { FactoryGirl.create(:event, leader_user_id: current_user.id) }
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

  describe 'cancel created event', js: true do
    let!(:event) { FactoryGirl.create(:event, leader_user_id: current_user.id) }
    before do
      visit event_path(event)
      click_link I18n.t('layouts.event_delete')
    end

    context 'clicking event delete link' do
      let!(:canceled_event) { Event.find(event) }
      it 'status should be cancel' do
        expect(canceled_event).to be_cancel
      end
      it 'cancel_at should have value' do
        expect(canceled_event.cancel_at).to be_truthy
      end
    end
  end

  describe 'participate event' do
    let!(:leader_user) { FactoryGirl.create(:user) }
    let!(:event) { FactoryGirl.create(:event, leader_user_id: leader_user.id) }
    let!(:my_event) { FactoryGirl.create(:event, leader_user_id: current_user.id) }

    context 'visiting event detail page' do
      before do
        visit event_path(event)
      end

      it 'content should have input form for participant' do
        expect(page).to have_selector(:link_or_button, I18n.t('layouts.link_to_participate_event'))
      end
    end

    context 'visiting my event detail page' do
      before do
        visit event_path(my_event)
      end

      it 'content should not have input form for participant' do
        expect(page).not_to have_selector(:link_or_button, I18n.t('layouts.link_to_participate_event'))
      end
    end

    context 'after participate event' do
      before do
        visit event_path(event)
      end

      describe 'participate event' do
        it 'record count in participant table increase by 1' do
          expect { click_button I18n.t('layouts.link_to_participate_event') }.to change(Participant, :count).by(1)
        end
      end

      describe 'success to participating event' do
        before do
          click_button I18n.t('layouts.link_to_participate_event')
        end

        it 'redirect to events detail page 'do
          expect(page.current_path).to eq event_path(event)
        end
        it 'content should have layouts.notice.participate_event' do
          expect(page).to have_content I18n.t('layouts.notice.participate_event')
        end

        context 'visiting event detail page' do
          before do
            visit event_path(event)
          end

          it 'content should have layouts.link_to_cancel_participate' do
            expect(page).to have_selector(:link_or_button, I18n.t('layouts.link_to_cancel_participate'))
          end
        end

        context 'after clicking cancel button' do
          before do
            visit event_path(event)
          end

          describe 'un-participate event' do
            it 'record count in participant table decrease by 1' do
              expect { click_link I18n.t('layouts.link_to_cancel_participate') }.to change(Participant, :count).by(-1)
            end
          end

          describe 'success to un-participate event' do
            before do
              click_link I18n.t('layouts.link_to_cancel_participate')
            end

            it 'redirect to events detail page 'do
              expect(page.current_path).to eq event_path(event)
            end
            it 'content should have layouts.notice.cancel_participate_event' do
              expect(page).to have_content I18n.t('layouts.notice.cancel_participate_event')
            end
          end
        end
      end

      describe 'event participants is max' do
        let!(:event_limit_max_participants) { FactoryGirl.create(:event, leader_user_id: leader_user.id, status: Event.statuses[:participants_max]) }

        context 'visiting event list' do
          before do
            visit events_path
          end

          it 'content should not have event name' do
            expect(page).not_to have_content event_limit_max_participants.name
          end
        end

        context 'visiting event detail page directly' do
          before do
            visit event_path(event_limit_max_participants)
          end

          it 'content should not have input form for participant' do
            expect(page).not_to have_selector(:link_or_button, I18n.t('layouts.link_to_participate_event'))
          end
        end
      end

      context 'giving canceled event, and visiting event detail page' do
        let!(:event_canceled) { FactoryGirl.create(:event, status: Event.statuses[:cancel]) }
        before do
          visit event_path(event_canceled)
        end

        it 'content should have layouts.cannot_participate' do
          expect(page).to have_content(I18n.t('layouts.cannot_participate'))
        end
      end

      describe 'participated event list (in event index page)' do
        let!(:event) { FactoryGirl.create(:event) }
        let!(:participant) { FactoryGirl.create(:participant, event_id: event.id, user_id: current_user.id) }

        context 'participating event, and visit event index' do
          before do
            visit events_path
          end
          it 'should content has participated event name' do
            within '#participating_event_list' do
              expect(page).to have_content event.name
            end
          end
        end

        context 'participating event, and visit event detail page' do
          before do
            visit event_path(event.id)
          end
          it 'should content has my name' do
            within '#participants_list' do
              expect(page).to have_content current_user.name
            end
          end
        end

        context 'giving canceled event'  do
          let!(:canceled_event) { FactoryGirl.create(:event, status: Event.statuses[:cancel]) }
          let!(:participant) { FactoryGirl.create(:participant_without_validation, event_id: canceled_event.id, user_id: current_user.id) }

          before do
            visit events_path
          end
          it 'content should also has participated (canceled) event name' do
            within '#participating_event_list' do
              expect(page).to have_content canceled_event.name
            end
          end
          it 'content should has event_status.cancel' do
            within '#participating_event_list' do
              expect(page).to have_content I18n.t('event_status.cancel')
            end
          end
        end

        context 'giving participants_max event' do
          let!(:max_participants_event) { FactoryGirl.create(:event, status: Event.statuses[:participants_max]) }
          let!(:participant) { FactoryGirl.create(:participant_without_validation, event_id: max_participants_event.id, user_id: current_user.id) }

          before do
            visit events_path
          end
          it 'content should also has participated (participants_max) event name' do
            within '#participating_event_list' do
              expect(page).to have_content max_participants_event.name
            end
          end
          it 'content should also has event_status.participants_max' do
            within '#participating_event_list' do
              expect(page).to have_content I18n.t('event_status.participants_max')
            end
          end
        end

        context 'giving past event'  do
          let!(:past_event) { FactoryGirl.create(:event_without_validation, event_at: 3.days.ago) }
          let!(:participant) { FactoryGirl.create(:participant_without_validation, event_id: past_event.id, user_id: current_user.id) }

          before do
            visit events_path
          end
          it 'content should not has participated (past) event name' do
            within '#participating_event_list' do
              expect(page).not_to have_content past_event.name
            end
          end
        end
      end
    end
  end

end
