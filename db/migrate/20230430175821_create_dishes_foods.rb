class CreateDishesFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :dishes_foods do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true

      t.timestamps
    end
  end
end
