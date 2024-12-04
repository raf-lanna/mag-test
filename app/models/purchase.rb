class Purchase < ApplicationRecord
  validates :client_id, :client_name, :order_id, :product_id,
            :product_value, :purchase_date, presence: true
  validates :client_id, :order_id, :product_id, numericality: { only_integer: true }
  validates :product_value, numericality: true

  def initialize(line)
    if line.present?
      set_client_id(line[0, 10])
      set_client_name(line[11, 44])
      set_order_id(line[55, 10])
      set_product_id(line[65, 10])
      set_product_value(line[75, 12])
      set_purchase_date(line[87, 8])
    end

    super()
  end

  def set_client_id(value)
    @client_id = value&.to_i
  end
  def client_id
    @client_id
  end

  def set_client_name(value)
    @client_name = value[11, 44]&.strip
  end
  def client_name
    @client_name
  end

  def set_order_id(value)
    @order_id = value&.to_i
  end
  def order_id
    @order_id
  end

  def set_product_id(value)
    @product_id = value&.to_i
  end
  def product_id
    @product_id
  end

  def set_product_value(value)
    @product_value = value&.to_f
  end
  def product_value
    @product_value
  end

  def set_purchase_date(value)
    begin
      @purchase_date = value&.to_date
    rescue
      errors.add(:purchase_date, "invalid date")
    end
  end
  def purchase_date
    @purchase_date
  end
end
