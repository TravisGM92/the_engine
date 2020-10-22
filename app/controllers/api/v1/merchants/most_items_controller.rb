# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class MostItemsController < ApplicationController
        def index
          render json: MerchantSerializer.new(Merchant.most_items(params[:quantity]))
        end
      end
    end
  end
end
