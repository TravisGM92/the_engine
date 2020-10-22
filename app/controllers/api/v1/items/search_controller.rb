# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def show
          case params.keys[0]
          when 'name'
            render json: ItemSerializer.new(Item.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%").first)
          when 'description'
            render json: ItemSerializer.new(Item.where(['description LIKE ?', "%#{params[:description]}%"]).first)
          when 'unit_price'
            render json: ItemSerializer.new(Item.where(unit_price: params[:unit_price]))
          else
            attribute = params.keys[0].to_sym
            render json: ItemSerializer.new(Item.where(attribute => params[attribute]))
          end
        end

        def index
          case params.keys[0]
          when 'name'
            render json: ItemSerializer.new(Item.where(['LOWER(name) LIKE ?', "%#{params[:name].downcase}%"]))
          when 'description'
            render json: ItemSerializer.new(Item.where(['description LIKE ?', "%#{params[:description]}%"]))
          when 'unit_price'
            render json: ItemSerializer.new(Item.where(unit_price: params[:unit_price]))
          else
            attribute = params.keys[0].to_sym
            render json: ItemSerializer.new(Item.where(attribute => params[attribute]))
          end
        end

        private

        def item_params
          params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
        end
      end
    end
  end
end
