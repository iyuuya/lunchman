class AddIdentityIdToUser < ActiveRecord::Migration
  def change
    add_column(:users, :identity_id, :indeger)
  end
end
