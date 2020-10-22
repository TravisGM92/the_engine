# frozen_string_literal: true

module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        def show
          merchant = Item.find(params[:id]).merchant
          render json: MerchantSerializer.new(merchant)
        end
      end
    end
  end
end
