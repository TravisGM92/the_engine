require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key('id')
      expect(item['id']).to be_an(Integer)

      expect(item).to have_key('description')
      expect(item['description']).to be_a(String)

      expect(item).to have_key('unit_price')
      expect(item['unit_price']).to be_an(Integer)

      expect(item).to have_key('merchant_id')
      expect(item['merchant_id']).to be_an(Integer)

      expect(item).to have_key('created_at')
      expect(item['created_at']).to be_a(String)

      expect(item).to have_key('updated_at')
      expect(item['updated_at']).to be_a(String)

    end
  end

    it "can get one item" do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      item = JSON.parse(response.body)

      expect(item).to have_key('id')
      expect(item['id']).to be_an(Integer)

      expect(item).to have_key('description')
      expect(item['description']).to be_a(String)

      expect(item).to have_key('unit_price')
      expect(item['unit_price']).to be_an(Integer)

      expect(item).to have_key('merchant_id')
      expect(item['merchant_id']).to be_an(Integer)

      expect(item).to have_key('created_at')
      expect(item['created_at']).to be_a(String)

      expect(item).to have_key('updated_at')
      expect(item['updated_at']).to be_a(String)
  end

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = ({
      name: 'The hammer',
      description: 'Nice to hit things with',
      unit_price: 3,
      merchant_id: merchant.id,
      created_at: '01-06-1993',
      updated_at: '02-12-2000'
      })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last
      expect(response).to be_successful

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.created_at).to eq(item_params[:created_at])
      expect(created_item.updated_at).to eq(item_params[:updated_at])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'The Spoon' }
    headers = {"CONTENT_TYPE" => 'application/json'}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('The Spoon')
  end

  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
