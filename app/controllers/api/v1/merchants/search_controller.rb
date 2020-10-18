class Api::V1::Merchants::SearchController < ApplicationController
  def show
    render json: Merchant.find_by(merchant_params)
  end

  def index
    if params.keys[0] == "name"
      names = Merchant.downcase_split_names(params[:name])
      render json: Merchant.where("LOWER(name) LIKE ?", "%#{names[0]}%").or(Merchant.where("LOWER(name) LIKE ?", "%#{names[1]}%"))
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
