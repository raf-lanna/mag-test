class PurchasesController < ApplicationController
  before_action :set_legacy_purchases_array, :validate_payload

  def create
    purchases = []
    @legacy_purchases.each do |legacy_purchase|
      logger.debug("processing legacy purchase: #{legacy_purchase}")

      purchase = Purchase.new(legacy_purchase)

      if purchase.valid?
        purchases << purchase
      else
        return head :unprocessable_entity
      end
    end

    render json: PurchaseJsonBuilderService.call(purchases)
  end

  private

  def set_legacy_purchases_array
    @legacy_purchases = if request.body.class == File
      request.raw_post.split("\n")
    else
     request.body.string.split("\n")
    end
  end

  def validate_payload
    if request.body.size.zero?
      head :bad_request
      false
    else
      @legacy_purchases.each do |legacy_purchase|
        unless legacy_purchase[0, 10] !~ /\D/ &&
               legacy_purchase[11, 44].match?(/\A[a-zA-Z' .]*\z/) &&
               legacy_purchase[55, 10] !~ /\D/ &&
               legacy_purchase[65, 10] !~ /\D/ &&
               legacy_purchase[75, 12].strip.tr(".", '')  !~ /\D/ &&
               legacy_purchase[87,8] !~ /\D/
          head :unprocessable_entity
          false
        end
      end
    end
  end
end
