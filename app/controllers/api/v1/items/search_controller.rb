class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: Item.find_by(item_params)
  end

  def index
    if params.keys[0] == "name"
      render json: Item.where(["LOWER(name) LIKE ?", "%#{params[:name].downcase}%"])
    elsif params.keys[0] == "description"
      render json: Item.where(["description LIKE ?", "%#{params[:description]}%"])
    elsif params.keys[0] == "unit_price"
      render json: Item.where(unit_price: params[:unit_price])
    else
      attribute = params.keys[0].to_sym
      render json: Item.where(attribute => params[attribute])
    end
  end

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
