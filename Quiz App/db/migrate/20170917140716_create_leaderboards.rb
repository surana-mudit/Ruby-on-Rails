class CreateLeaderboards < ActiveRecord::Migration[5.1]
  def change
    create_table :leaderboards do |t|
      t.string :user_email
      t.integer :quiz_id
      t.integer :score
      t.integer :state

      t.timestamps
    end
  end
end
