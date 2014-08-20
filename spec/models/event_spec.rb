require 'rails_helper'

describe Event do

  describe "relationships" do
    it { should belong_to :leader_user }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :event_at }
    it { should validate_presence_of :leader_user_id }
    it { should validate_presence_of :status }
  end

  describe 'when giving invalid event_at ' do
    subject { FactoryGirl.build(:event, :as_invalid_event_at ) }
    it { should_not be_valid  }
  end

  describe 'when giving invalid dead_line ' do
    subject { FactoryGirl.build(:event, :as_invalid_deadline ) }
    it { should_not be_valid  }
  end
end
