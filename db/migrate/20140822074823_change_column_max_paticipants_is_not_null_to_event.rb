class ChangeColumnMaxPaticipantsIsNotNullToEvent < ActiveRecord::Migration
  def change
    change_column :events, :max_participants, :integer, null: false
  end
end
