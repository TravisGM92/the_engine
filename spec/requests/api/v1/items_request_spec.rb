# frozen_string_literal: true

require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items['data'].count).to eq(5)
    items['data'].each do |item|
      expect(item['attributes']).to have_key('description')
      expect(item['attributes']['description']).to be_a(String)

      expect(item['attributes']).to have_key('unit_price')
      expect(item['attributes']['unit_price']).to be_an(Float)

      expect(item['attributes']).to have_key('merchant_id')
      expect(item['attributes']['merchant_id']).to be_an(Integer)

      expect(item['attributes']).to have_key('created_at')
      expect(item['attributes']['created_at']).to be_a(String)

      expect(item['attributes']).to have_key('updated_at')
      expect(item['attributes']['updated_at']).to be_a(String)
    end
  end

  it 'can get one item' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item['data']['attributes']).to have_key('description')
    expect(item['data']['attributes']['description']).to be_a(String)

    expect(item['data']['attributes']).to have_key('unit_price')
    expect(item['data']['attributes']['unit_price']).to be_an(Float)

    expect(item['data']['attributes']).to have_key('merchant_id')
    expect(item['data']['attributes']['merchant_id']).to be_an(Integer)

    expect(item['data']['attributes']).to have_key('created_at')
    expect(item['data']['attributes']['created_at']).to be_a(String)

    expect(item['data']['attributes']).to have_key('updated_at')
    expect(item['data']['attributes']['updated_at']).to be_a(String)
  end

  it 'can create a new item' do
    merchant = create(:merchant)

    item_params = {
      name: 'The hammer',
      id: '1',
      description: 'Nice to hit things with',
      unit_price: 3,
      merchant_id: merchant.id,
      created_at: '01-06-1993',
      updated_at: '02-12-2000'
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)
    created_item = Item.last
    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.created_at).to eq(item_params[:created_at])
    expect(created_item.updated_at).to eq(item_params[:updated_at])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can update an existing item' do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     id: 2,
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })
    previous_name = Item.last.name
    item_params = { name: 'The Spoon' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{item1.id}", headers: headers, params: JSON.generate(item_params)
    item = Item.find_by(id: item1.id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('The Spoon')
  end

  it 'can destroy an item' do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     id: 3,
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })

    expect(Item.count).to eq(1)

    expect { delete "/api/v1/items/#{item1.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect { Item.find(item1.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can find an item by it's name" do
    data = create(:item)

    get "/api/v1/items/find?name=#{data.name}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['name']).to eq(data[:name])
  end

  it "can find an item by it's id" do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     id: 3,
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })

    get "/api/v1/items/find?id=#{item1.id}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'][0]['attributes']['name']).to eq(item1[:name])
  end

  it "can find an item by it's description" do
    data = create(:item)

    get "/api/v1/items/find?description=#{data.description}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data']['id']).to eq((data[:id]).to_s)
  end

  it "can find an item by it's unit price" do
    data = create(:item)

    get "/api/v1/items/find?unit_price=#{data.unit_price}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'][0]['attributes']['name']).to eq(data[:name])
  end

  it "can find an item by it's created at" do
    data = create(:item)

    get "/api/v1/items/find?created_at=#{data.created_at}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'][0]['attributes']['name']).to eq(data[:name])
  end

  it "can find an item by it's updated at" do
    data = create(:item)

    get "/api/v1/items/find?updated_at=#{data.updated_at}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'][0]['attributes']['name']).to eq(data[:name])
  end

  it 'can find multiple items that fit the name' do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })

    merchant.items.create!({
                             name: 'The Yello hammer',
                             description: 'Nice to hit things with',
                             unit_price: 3,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    merchant.items.create!({
                             name: 'The Yello Screwdriver',
                             description: 'Nice to screw things with',
                             unit_price: 2,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    get "/api/v1/items/find_all?name=#{item1[:name]}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'].length).to eq(2)
  end

  it 'can find multiple items that fit the desription' do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })

    merchant.items.create!({
                             name: 'The Yello hammer',
                             description: 'Nice to hit things with',
                             unit_price: 3,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    merchant.items.create!({
                             name: 'The Yello Screwdriver',
                             description: 'Nice to screw things with',
                             unit_price: 2,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    get "/api/v1/items/find_all?description=#{item1[:description][0..6]}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'].length).to eq(3)
  end

  it 'can find multiple items that fit the unit price' do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })

    merchant.items.create!({
                             name: 'The Yello hammer',
                             description: 'Nice to hit things with',
                             unit_price: 3,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    merchant.items.create!({
                             name: 'The Yello Screwdriver',
                             description: 'Nice to screw things with',
                             unit_price: 2,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    get "/api/v1/items/find_all?unit_price=#{item1[:unit_price]}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'].length).to eq(2)
  end

  it 'can find multiple items that fit the created at' do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })

    merchant.items.create!({
                             name: 'The Yello hammer',
                             description: 'Nice to hit things with',
                             unit_price: 3,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    merchant.items.create!({
                             name: 'The Yello Screwdriver',
                             description: 'Nice to screw things with',
                             unit_price: 2,
                             created_at: '01-06-1993',
                             updated_at: '04-12-2010'
                           })

    get "/api/v1/items/find_all?created_at=#{item1[:created_at]}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'].length).to eq(2)
  end

  it 'can find multiple items that fit the updated at' do
    merchant = create(:merchant)
    item1 = merchant.items.create!({
                                     name: 'Hammer',
                                     description: 'Nice to hit things with',
                                     unit_price: 3,
                                     created_at: '01-06-1993',
                                     updated_at: '02-12-2000'
                                   })

    merchant.items.create!({
                             name: 'The Yello hammer',
                             description: 'Nice to hit things with',
                             unit_price: 3,
                             created_at: '02-06-1980',
                             updated_at: '04-12-2010'
                           })

    merchant.items.create!({
                             name: 'The Yello Screwdriver',
                             description: 'Nice to screw things with',
                             unit_price: 2,
                             created_at: '01-06-1993',
                             updated_at: '04-12-2010'
                           })

    get "/api/v1/items/find_all?created_at=#{item1[:created_at]}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'].length).to eq(2)
  end

  it 'can create an item with no id passed in params' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)
    item_params = {
      name: 'The hammer',
      description: 'Nice to hit things with',
      unit_price: 3,
      merchant_id: merchant.id,
      created_at: '01-06-1993',
      updated_at: '02-12-2000'
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)
    created_item = Item.last
    expect(response).to be_successful
    expect(created_item.id).to eq(item1.id + 1)
  end

  it 'gets 204 error when there is no match for one item' do

    get '/api/v1/items/find?name='

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['code']).to eq(204)
    expect(result['data']['attributes']['message']).to eq('name missing')
  end

  it 'gets 204 error when there is no match for several items' do

    get '/api/v1/items/find_all?name='

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['code']).to eq(204)
    expect(result['data']['attributes']['message']).to eq('name missing')
  end
end
