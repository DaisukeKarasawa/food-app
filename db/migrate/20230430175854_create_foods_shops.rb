class CreateFoodsShops < ActiveRecord::Migration[7.0]
  def change
    create_table :foods_shops do |t|
      t.references :food, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
