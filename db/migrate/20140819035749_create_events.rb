class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :leader_user_id
      t.datetime :event_at
      t.datetime :deadline_at
      t.text :comment
      t.integer :max_participants
      t.integer :venue_id
      t.integer :status
      t.datetime :cancel_at

      t.timestamps
    end
  end
end
