class AddIsArchivedToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :is_archived, :boolean
  end
end
