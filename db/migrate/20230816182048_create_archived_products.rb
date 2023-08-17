class CreateArchivedProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :archived_products do |t|
      t.string :title
      t.text :description
      t.float :price
      t.integer :category
      t.integer :vegetarian

      t.timestamps
    end
  end
end
