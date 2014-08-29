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
      let(:event_limit_max_participants) { FactoryGirl.create(:event, max_participants: 2) }

      let!(:users) { FactoryGirl.create_list(:user, 2) }
      let!(:user_new) { FactoryGirl.create(:user) }
      let!(:participant) { FactoryGirl.build(:participant, event_id: event_limit_max_participants.id, user_id: user_new.id) }

      before do
        users.each do |user|
          FactoryGirl.create(:participant, event_id: event_limit_max_participants.id, user_id: user.id)
        end
      end

      subject { participant }
      it { is_expected.not_to be_valid }
    end
  end
end
