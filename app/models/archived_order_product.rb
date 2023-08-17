class ArchivedOrderProduct < ApplicationRecord
  belongs_to :archived_order
  belongs_to :archived_product
end
