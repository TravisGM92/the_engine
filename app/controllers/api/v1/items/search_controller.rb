class Api::V1::Items::SearchController < ApplicationController
  def show
    if params.keys[0] == "name"
      render json: Item.where(["LOWER(name) LIKE ?", "%#{params[:name].downcase}"])
    elsif params.keys[0] == "description"
      render json: Item.where(["LOWER(description) LIKE ?", "%#{params[:description].downcase}"])
    else
      render json: Item.find_by(item_params)
    end
  end

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
