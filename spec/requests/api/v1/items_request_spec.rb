require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful

  end
end
