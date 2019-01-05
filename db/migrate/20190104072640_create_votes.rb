class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer    :value
      t.references :user
      t.references :votable, polymorphic: true
      t.timestamps null: false
    end
    add_index :votes, [:user_id, :votable_id, :votable_type, :value], unique: true, :name => 'search_vote'
  end
end
