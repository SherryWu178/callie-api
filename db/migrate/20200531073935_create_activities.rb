class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :title
      t.float :duration
      t.float :target
      t.references :user, foreign_key: true, index: true
      
      t.timestamps
    end
  end
end
