class ChangeColumnMaxPaticipantsIsNotNullToEvent < ActiveRecord::Migration
  def change
    change_column :events, :max_paticipants, :integer, null: false
  end
end
