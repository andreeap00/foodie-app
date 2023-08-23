class RemoveIndexFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_index :orders, column: :user_id
  end
end
