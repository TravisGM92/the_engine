class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id])
  end

  def create
    render json: Merchant.create(merchant_params)
  end

  def destroy
    render json: Merchant.destroy(params[:id])
  end

  def update
    render json: Merchant.update(params[:id], merchant_params)
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name, :created_at, :updated_at)
  end
end
