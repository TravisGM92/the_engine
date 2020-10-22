# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
      end

      def create
        if params[:id].nil?
          id = Merchant.last[:id].to_i + 1
          render json: MerchantSerializer.new(Merchant.create!({ id: id.to_s, name: merchant_params[:name], created_at: Time.now, updated_at: Time.now }))
        else
          render json: MerchantSerializer.new(Merchant.create!(merchant_params))
        end
      end

      def destroy
        Merchant.destroy(params[:id])
        render status: 204
      end

      def update
        render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
      end

      private

      def merchant_params
        params.permit(:name, :created_at, :updated_at)
      end
    end
  end
end
