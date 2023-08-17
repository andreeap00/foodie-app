class CreateArchivedOrderProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :archived_order_products do |t|
      t.references :archived_order, null: false, foreign_key: true
      t.references :archived_product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
