# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def show
          if params.keys[0] == 'name' && params.values[0] != ''
            render json: MerchantSerializer.new(Merchant.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%").first)
          elsif params.values[0] == ''
            render json: { data: { id: 'null', attributes: { code: 204, message: "#{params.keys[0]} missing" } } }
          else
            attribute = params.keys[0].to_sym
            render json: MerchantSerializer.new(Merchant.where(attribute => params[attribute]))
          end
        end

        def index
          if params.keys[0] == 'name' && params.values[0] != ''
            Merchant.downcase_split_names(params[:name])
            render json: MerchantSerializer.new(Merchant.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%"))
          elsif params.values[0] == ''
            render json: { data: { id: 'null', attributes: { code: 204, message: "#{params.keys[0]} missing" } } }
          else
            attribute = params.keys[0].to_sym
            render json: MerchantSerializer.new(Merchant.where(attribute => params[attribute]))
          end
        end
      end
    end
  end
end
