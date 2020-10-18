class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if params.keys[0] == "name"
      render json: Merchant.where(["LOWER(name) LIKE ?", "%#{params[:name].downcase}"])
    else
      render json: Merchant.find_by(merchant_params)
    end
  end

  private

  def merchant_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
