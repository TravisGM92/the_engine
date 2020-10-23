# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def show
          if params.keys[0] == 'name' && params.values[0] != ""
            render json: ItemSerializer.new(Item.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%").first)
          elsif params.keys[0] == 'description' && params.values[0] != ""
            render json: ItemSerializer.new(Item.where(['description LIKE ?', "%#{params[:description]}%"]).first)
          elsif params.keys[0] == 'unit_price' && params.values[0] != ""
            render json: ItemSerializer.new(Item.where(unit_price: params[:unit_price]))
          elsif params.values[0] == ""
            render json: {data: {id: "null", attributes: {code: 204, message: "#{params.keys[0]} missing"}}}
          else
            attribute = params.keys[0].to_sym
            render json: ItemSerializer.new(Item.where(attribute => params[attribute]))
          end
        end

        def index
          if params.keys[0] == 'name' && params.values[0] != ""
            render json: ItemSerializer.new(Item.where(['LOWER(name) LIKE ?', "%#{params[:name].downcase}%"]))
          elsif params.keys[0] == 'description' && params.values[0] != ""
            render json: ItemSerializer.new(Item.where(['description LIKE ?', "%#{params[:description]}%"]))
          elsif params.keys[0] == 'unit_price' && params.values[0] != ""
            render json: ItemSerializer.new(Item.where(unit_price: params[:unit_price]))
          elsif params.values[0] == ""
            render json: {data: {id: "null", attributes: {code: 204, message: "#{params.keys[0]} missing"}}}
          else
            attribute = params.keys[0].to_sym
            render json: ItemSerializer.new(Item.where(attribute => params[attribute]))
          end
        end
      end
    end
  end
end
