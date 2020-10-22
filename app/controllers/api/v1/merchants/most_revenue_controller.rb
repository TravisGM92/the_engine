# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class MostRevenueController < ApplicationController
        def index
          render json: MerchantSerializer.new(Merchant.highest_revenue(params[:quantity]))
        end

        def show
          render json: RevenueSerializer.new(Merchant.revenue_within_dates(params[:start], params[:end]))
        end
      end
    end
  end
end
