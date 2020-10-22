# frozen_string_literal: true

class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }
  attribute :revenue do |numb|
    numb
  end
end
