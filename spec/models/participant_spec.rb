require 'rails_helper'

describe Participant do
  describe '#participate_event' do
    let!(:event) { FactoryGirl.create(:event) }
    let!(:participant) { FactoryGirl.build(:participant, event_id: event.id) }

    it { expect { participant.create_participant }.to change(Participant, :count).by(1) }

    context 'giving un-participatable event' do
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

  end
end
