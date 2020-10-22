# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        if params[:id].nil?
          id = Item.last[:id].to_i + 1
          render json: ItemSerializer.new(Item.create({ id: id.to_s, name: item_params[:name], description: item_params[:description], unit_price: item_params[:unit_price], merchant_id: item_params[:merchant_id], created_at: Time.now, updated_at: Time.now }))
        else
          render json: ItemSerializer.new(Item.create(item_params))
        end
      end

      def update
        render json: ItemSerializer.new(Item.update(params[:id], item_params))
      end

      def destroy
        Item.destroy(params[:id])
        render status: 204
      end

      private

      def item_params
        params.permit(:name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
      end
    end
  end
end
