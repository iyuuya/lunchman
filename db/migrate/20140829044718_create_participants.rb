class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer   :event_id,  null: false
      t.integer   :user_id,   null: false
      t.string    :comment

      t.timestamps
    end
  end
end
