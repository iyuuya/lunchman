class ChangeNotNullOptionsToEvents < ActiveRecord::Migration
  def change
    change_column :events, :name, :string, null: false
    change_column :events, :event_at, :datetime, null: false
    change_column :events, :leader_user_id, :integer, null: false
    change_column :events, :status, :integer, null: false
  end
end
