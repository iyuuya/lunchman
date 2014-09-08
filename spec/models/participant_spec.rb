require 'rails_helper'

describe Participant do
  describe 'Validator' do
    context 'when event status is cancel' do
      let!(:event) { FactoryGirl.create(:event, status: Event.statuses[:cancel]) }
      let!(:participant) { FactoryGirl.build(:participant, event_id: event.id) }

      subject { participant }
      it { is_expected.not_to be_valid }
    end

    context 'when participants is max' do
      let(:limited_max_participants_event) { FactoryGirl.create(:event, max_participants: 2) }

      let!(:users) { FactoryGirl.create_list(:user, 2) }
      let!(:user_new) { FactoryGirl.create(:user) }
      let!(:participant) { FactoryGirl.build(:participant, event_id: limited_max_participants_event.id, user_id: user_new.id) }

      before do
        users.each do |user|
          FactoryGirl.create(:participant, event_id: limited_max_participants_event.id, user_id: user.id)
        end
      end

      subject { participant }
      it { is_expected.not_to be_valid }
    end

    context 'when deadline is coming' do
      let!(:deadlined_event) { FactoryGirl.create(:event_without_validation, deadline_at: 1.hours.ago) }
      let!(:participant) { FactoryGirl.build(:participant, event_id: deadlined_event.id) }

      subject { participant }
      it { is_expected.not_to be_valid }
    end

    describe 'event_id and user_id uniqueness' do
      let!(:event) {  FactoryGirl.create(:event) }
      let!(:event_id) { event.id }
      let!(:participant) { FactoryGirl.build(:participant, event_id: event_id, user_id: user_id) }
      let!(:same_participant) { FactoryGirl.build(:participant, event_id: event_id, user_id: user_id) }

      let!(:another_event) {  FactoryGirl.create(:event) }
      let!(:another_event_id) { another_event.id }
      let!(:another_participant) { FactoryGirl.build(:participant, event_id: another_event_id, user_id: user_id) }

      let!(:user_id) { 1 }

      before do
        participant.save
      end

      context 'givind same event_id and user_id event' do
        subject { same_participant }
        it 'should not be valid' do
          is_expected.not_to be_valid
        end
      end

      context 'giving another event_id event' do
        subject { another_participant }
        it 'should be valid' do
          is_expected.to be_valid
        end
      end
    end
  end
end
