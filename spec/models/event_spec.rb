require 'rails_helper'

describe Event do
  let!(:user) { FactoryGirl.create(:user) }

  describe 'relationships' do
    it { should belong_to :leader_user }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :event_at }
    it { should validate_presence_of :leader_user_id }
    it { should validate_presence_of :status }
    it { should validate_presence_of :max_participants }
  end

  describe '#participatable?' do
    subject { event.participatable? }

    context 'when valid event' do
      let!(:event) { FactoryGirl.build(:event) }
      it { is_expected.to be_truthy }
    end

    context 'when status is cancel' do
      let!(:event) { FactoryGirl.build(:event, status: 1) }
      it { is_expected.to be_falsey }
    end

    context 'when event_at is before now' do
      let!(:event) { FactoryGirl.build(:event, event_at: DateTime.now.yesterday) }
      it { is_expected.to be_falsey }
    end

    context 'when deadline_at is nil' do
      let!(:event) { FactoryGirl.build(:event, deadline_at: nil) }
      it { is_expected.to be_truthy }
    end

    context 'when deadline_at is before now' do
      let!(:event) { FactoryGirl.build(:event, deadline_at: DateTime.now.yesterday) }
      it { should be_falsey }
    end
  end

  describe 'scope' do
    describe '#participatable' do
      let!(:event) { FactoryGirl.create(:event) }
      let!(:event_without_validation) {
        [
          FactoryGirl.create(:event_without_validation, status: Event.statuses[:cancel]),
          FactoryGirl.create(:event_without_validation, event_at: 1.days.ago),
          FactoryGirl.create(:event_without_validation, deadline_at: 1.days.ago)
        ]
      }

      subject { Event.participatable }
      it 'giving valid data, should select created data' do
        is_expected.to include(event)
      end
      it 'giving invalid data, should not select created data' do
        is_expected.not_to include(*event_without_validation)
      end
    end

    describe '#not_held' do
      subject { Event.not_held }
      context 'giving valid data' do
        let!(:event) { FactoryGirl.create(:event) }
        it 'should select created data' do
          is_expected.to include(event)
        end
      end

      context 'giving past event data' do
        let!(:event) { FactoryGirl.create(:event_without_validation, event_at: 3.days.ago) }
        it 'should not select created data' do
          is_expected.not_to include(event)
        end
      end
    end
  end

  describe '#leader?' do
    let!(:another_user) { FactoryGirl.create(:user) }
    subject { event.leader?(user) }

    context 'creating event with user' do
      let!(:event) { FactoryGirl.create(:event, leader_user_id: user.id) }
      it { is_expected.to be_truthy }
    end

    context 'creating event with another user ' do
      let!(:event) { FactoryGirl.create(:event, leader_user_id: another_user.id) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#participated?' do
    let!(:event) { FactoryGirl.create(:event) }
    let!(:participant) { FactoryGirl.create(:participant, event_id: event.id, user_id: user.id) }

    subject { event.participated?(user) }
    it { is_expected.to be_truthy }

    context 'giving another user' do
      let!(:another_user) { FactoryGirl.create(:user) }

      subject { event.participated?(another_user) }
      it { is_expected.to be_falsey }
    end
  end

  describe 'user participate' do
    let!(:event) { FactoryGirl.create(:event, max_participants: 4) }
    let!(:users) { FactoryGirl.create_list(:user, 3) }
    let!(:participant) { FactoryGirl.build(:participant, event_id: event.id) }
    let!(:participants) { FactoryGirl.build_list(:participant, 3) }

    before do
      users.each_with_index do |user, i|
        participants[i].user_id = user.id
        participants[i].event_id = event.id
        participants[i].participate!('test')
      end
    end

    context 'event max_participants is 4, and 3 users participated' do
      describe '#participate_count' do
        subject { event.participants.count }
        it { is_expected.to eq 3 }
      end

      describe '#participate_count_max?' do
        subject { event.participate_count_max? }
        it { is_expected.to be_falsey }
      end

      context 'participating another user' do
        let!(:another_user) { FactoryGirl.create(:user) }
        before do
          participant.user = another_user
          participant.participate!('test')
        end

        describe '#participate_count_max' do
          subject { event.participate_count_max? }
          it  { is_expected.to be_truthy }
        end
      end
    end
  end
end
