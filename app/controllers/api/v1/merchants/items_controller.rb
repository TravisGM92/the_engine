# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          items = Merchant.find(params[:id]).items
          render json: ItemSerializer.new(items)
        end
      end
    end
  end
end
