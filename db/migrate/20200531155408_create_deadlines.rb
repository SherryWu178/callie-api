class CreateDeadlines < ActiveRecord::Migration[6.0]
  def change
    create_table :deadlines do |t|
      t.string :title
      t.datetime :datetime
      t.references :activity, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.boolean :allDay

      t.timestamps
    end
  end
end
