class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :completion
      t.float :duration
      t.belongs_to :activity, :foreign_key: true, index: true
      t.belongs_to :user, :foreign_key: true, index: true
      
      t.timestamps
    end
  end
end
