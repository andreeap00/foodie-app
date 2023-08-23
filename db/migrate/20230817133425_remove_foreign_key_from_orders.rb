class RemoveForeignKeyFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :orders, column: :user_id
  end
end
