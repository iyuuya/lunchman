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

  describe 'invalid date' do
    let( :event ){ FactoryGirl.create( :event ) }

    it "when event_at is before now " do
      event.event_at = Time.now - rand(1..30).days
      event.deadline_at = event.event_at + rand(1..30).hours

      expect(event).not_to be_valid
    end

    it 'when dead_line is after event_at ' do
      event.event_at = rand(1..30).days.from_now
      event.deadline_at = event.event_at + rand(1..30).hours

      expect(event).not_to be_valid
    end
  end
end
