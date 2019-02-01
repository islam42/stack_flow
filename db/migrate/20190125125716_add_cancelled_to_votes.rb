class AddCancelledToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :cancelled, :boolean
  end
end
