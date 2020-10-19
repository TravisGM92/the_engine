class Api::V1::Merchants::SearchController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%").first)
  end

  def index
    if params.keys[0] == "name"
      names = Merchant.downcase_split_names(params[:name])
      render json: MerchantSerializer.new(Merchant.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%"))
    else
      attribute = params.keys[0].to_sym
      render json: Item.where(attribute => params[attribute])
    end
  end

  private

  def merchant_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
