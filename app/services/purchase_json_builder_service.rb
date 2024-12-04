class PurchaseJsonBuilderService < ApplicationService
  def initialize(purchases)
    @purchases = purchases.sort_by do
      |purchase| [purchase.client_id, purchase.order_id]
    end

    super()
  end

  def call
    json_response = []
    current_user_data = { 'orders'=> [] }
    current_client_id = nil
    current_order_id = nil

    @purchases.each do |purchase|
      if purchase.client_id != current_client_id
        unless current_user_data.count == 1
          json_response << current_user_data
          current_user_data = { 'orders'=> [] }
        end
        current_client_id = purchase.client_id
        current_user_data['user_id'] = purchase.client_id
        current_user_data['name'] = purchase.client_name
      end

      if purchase.order_id != current_order_id
        current_order_id = purchase.order_id

        current_user_data['orders'] << {
          'order_id'=> purchase.order_id,
          'total'=> 0.0,
          'date'=> purchase.purchase_date,
          'products'=> []
        }
      end

      products = current_user_data['orders'].select do |order|
        order['order_id'] == current_order_id
      end.first['products']
      products << {
        'product_id'=> purchase.product_id,
        'product_value'=> purchase.product_value
      }

      current_order = current_user_data['orders'].select do |order|
        order['order_id']==current_order_id
      end.first

      current_order['total'] = (
        current_order['total'] + purchase.product_value
      ).round(2)
    end

    json_response << current_user_data
  end
end