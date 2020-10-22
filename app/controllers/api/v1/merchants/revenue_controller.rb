# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class RevenueController < ApplicationController
        def show
          render json: RevenueSerializer.new(Merchant.merchant_revenue(params[:id]))
        end
      end
    end
  end
end
