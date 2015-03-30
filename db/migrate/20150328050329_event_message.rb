class EventMessage < ActiveRecord::Migration
  def change
    create_table :event_messages do |t|
      t.integer :event_id,   null: false
      t.text :message,   null: false
      t.integer :user_id,   null: false
      
      t.timestamps
    end
  end
end
