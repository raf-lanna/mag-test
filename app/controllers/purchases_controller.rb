class PurchasesController < ApplicationController
  def create
    return head :bad_request unless request.body.size > 0

    purchases = []

    lines = request.body.string.split("\n")
    lines.each do |line|
      logger.debug("line: #{line}")

      purchase = Purchase.new(line)

      if purchase.present? && purchase.valid?
        purchases << purchase
      else
        return head :unprocessable_entity
      end
    end

    head :ok
  end

  # TODO: validar se os campos são o esperado

  private

  def transform_data(line)
    return nil unless line.size == 95

    hash_data = Hash.new
    hash_data['client_id'] = line[0,10]&.to_i
    hash_data['client_name'] = line[11,44]&.strip
    hash_data['order_id'] = line[55,10]&.to_i
    hash_data['product_id'] = line[65,10]&.to_i
    hash_data['product_value'] = line[75,12]&.to_f
    hash_data['purchase_date'] = line[87,8]&.to_date

    hash_data
  end
end
