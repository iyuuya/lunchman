require 'spec_helper'

describe Validators::EventDateValidator do
  describe '#validate' do
    subject { event }

    context 'event_at is before now' do
      let!(:event) { FactoryGirl.build(:event, event_at: 1.hours.ago) }
      it { is_expected.not_to be_valid }
    end

    context 'deadline is after event_at' do
      let!(:event) { FactoryGirl.build(:event, event_at: 1.hours.from_now, deadline_at: 2.hours.from_now) }
      it { is_expected.not_to be_valid }
    end

    context 'deadline is nil' do
      let!(:event) { FactoryGirl.build(:event, deadline_at: nil) }
      it { is_expected.to be_valid }
    end

    context 'deadline is not nil, and before now' do
      let!(:event) { FactoryGirl.build(:event, deadline_at: 1.hours.ago) }
      it { is_expected.not_to be_valid }
    end
  end
end
