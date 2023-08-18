class AddIsArchivedToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :is_archived, :boolean
  end
end
