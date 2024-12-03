class Purchase < ApplicationRecord
  attr_accessor :client_id, :client_name, :order_id, :product_id,
                :product_value, :purchase_date

  validates :client_id, :client_name, :order_id, :product_id,
            :product_value, :purchase_date, presence: true

  # TODO: validate types
end
