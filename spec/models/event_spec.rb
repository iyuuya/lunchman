require 'rails_helper'

describe Event do
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
end
