class CreateRecipeUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_urls do |t|
      t.string :url
      t.references :dish, null: false, foreign_key: true

      t.timestamps
    end
  end
end
