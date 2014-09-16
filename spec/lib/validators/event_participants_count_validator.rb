require 'rails_helper'

describe Validators::EventParticipantsCountValidator do
  describe '#validate' do
    subject { event }
    let!(:event) { FactoryGirl.create(:event, max_participants: 2) }

    context 'participate less than max_participants' do
      let!(:participant) { FactoryGirl.build(:participant, event_id: event.id) }
      it { is_expected.to be_valid }
    end

    context 'participate more than max_participants' do
      let!(:users) { FactoryGirl.create_list(:user, 3) }
      before do
        users.each do |user|
          FactoryGirl.create(:participant_without_validation, user_id: user.id, event_id: event.id)
        end
      end

      it { is_expected.not_to be_valid }
    end
  end
end
