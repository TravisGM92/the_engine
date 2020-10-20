class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.highest_revenue(params[:quantity]))
  end

end
