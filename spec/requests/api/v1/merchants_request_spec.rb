# frozen_string_literal: true

require 'rails_helper'

describe 'Items API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].length).to eq(5)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:created_at)
      expect(merchant[:attributes][:created_at]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:updated_at)
      expect(merchant[:attributes][:updated_at]).to be_a(String)
    end
  end

  it 'can send one merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)

    expect(merchant).to have_key(:created_at)
    expect(merchant[:created_at]).to be_a(String)

    expect(merchant).to have_key(:updated_at)
    expect(merchant[:updated_at]).to be_a(String)
  end

  it 'can create a mechant' do
    merchant_params = {
      name: 'George Clooney',
      id: '3',
      created_at: '03-04-04',
      updated_at: '05-10-19'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)
    created_merchant = Merchant.last

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
    expect(created_merchant.created_at).to eq(merchant_params[:created_at])
    expect(created_merchant.updated_at).to eq(merchant_params[:updated_at])
  end

  it 'can update a merchant' do
    id = create(:merchant).id

    merchant_params = { updated_at: '2020-10-19' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
    merchant = Merchant.find_by(id: id)
    expect(response).to be_successful
    expect(merchant.updated_at).to_not eq('05-10-19')
    expect(merchant.updated_at).to eq('2020-10-19')
  end

  it 'can destroy an existing record' do
    merchant = create(:merchant)
    expect(Merchant.count).to eq(1)

    expect { delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect { Merchant.find(merchant.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can show all items related to that specific merchant' do
    merchants = create_list(:merchant, 2)
    expect(Merchant.count).to eq(2)

    item_params = {
      name: 'The hammer',
      id: 2,
      description: 'Nice to hit things with',
      unit_price: 3,
      merchant_id: merchants[0].id,
      created_at: '01-06-1993',
      updated_at: '02-12-2000'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)

    get "/api/v1/merchants/#{merchants[0].id}/items"

    expect(response).to be_successful
    expect(Merchant.count).to eq(2)
    expect(merchants[0].items.count).to eq(1)
    expect(merchants[1].items.count).to eq(0)
  end

  it "can show a specific merchant when given an item's id" do
    merchants = create_list(:merchant, 2)
    expect(Merchant.count).to eq(2)

    Item.create!({
                   name: 'The hammer',
                   id: 3,
                   description: 'Nice to hit things with',
                   unit_price: 3,
                   merchant_id: merchants[0].id,
                   created_at: '01-06-1993',
                   updated_at: '02-12-2000'
                 })

    id = Item.first.id

    get "/api/v1/items/#{id}/merchant"
    merchant_response = JSON.parse(response.body, symbolize_names: true)
    first_merchant = Merchant.first

    expect(response).to be_successful

    expect(merchant_response[:data][:attributes]).to have_key(:id)
    expect(merchant_response[:data][:attributes][:id]).to eq(first_merchant.id)

    expect(merchant_response[:data][:attributes]).to have_key(:name)
    expect(merchant_response[:data][:attributes][:name]).to eq(first_merchant.name)

    expect(merchant_response[:data][:attributes]).to have_key(:created_at)

    expect(merchant_response[:data][:attributes]).to have_key(:updated_at)
  end

  it "can find an item by it's name" do
    data = create(:merchant)

    get "/api/v1/merchants/find?name=#{data.name}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['name']).to eq(data[:name])
  end

  it "can find an item by it's created at" do
    data = create(:merchant)

    get "/api/v1/merchants/find?created_at=#{data.created_at}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'][0]['attributes']['name']).to eq(data[:name])
  end

  it "can find an item by it's updated at" do
    data = create(:merchant)

    get "/api/v1/merchants/find?updated_at=#{data.updated_at}"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'][0]['attributes']['name']).to eq(data[:name])
  end

  it 'can find multiple merchants that fit the name' do
    Merchant.create!({
                       name: 'Hammer George',
                       created_at: '01-06-1993',
                       updated_at: '02-12-2000'
                     })

    Merchant.create!({
                       name: 'George Pinky',
                       created_at: '02-06-1980',
                       updated_at: '04-12-2010'
                     })

    Merchant.create!({
                       name: 'Timothy',
                       created_at: '01-06-1993',
                       updated_at: '04-12-2010'
                     })

    get '/api/v1/merchants/find_all?name=orge'
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'].length).to eq(2)
  end

  it 'can find merchants with most revenue, ranked and limited' do
    merchants = create_list(:merchant, 3)
    customers = create_list(:customer, 3)
    invoices = []
    merchants.each do |merchant|
      create_list(:item, 2, merchant_id: merchant.id)
      customers.each do |customer|
        invoices << create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      end
    end
    invoices.each { |invoice| create(:transaction, invoice_id: invoice.id) }

    x = 0
    invoices.each do |invoice|
      create(:invoice_item, invoice_id: invoice.id, quantity: x += 100, unit_price: 10)
    end

    get '/api/v1/merchants/most_revenue?quantity=2'
    expect(response).to be_successful

    result = JSON.parse(response.body)
    expect(result['data'].length).to eq(2)
  end

  it 'can find merchants who have sold the most items' do
    merchants = create_list(:merchant, 3)
    customers = create_list(:customer, 3)
    invoices = []
    merchants.each do |merchant|
      create_list(:item, 2, merchant_id: merchant.id)
      customers.each do |customer|
        invoices << create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      end
    end
    invoices.each { |invoice| create(:transaction, invoice_id: invoice.id) }

    x = 0
    invoices.each do |invoice|
      create(:invoice_item, invoice_id: invoice.id, quantity: x += 100, unit_price: 10)
    end

    get '/api/v1/merchants/most_items?quantity=2'
    expect(response).to be_successful

    result = JSON.parse(response.body)
    expect(result['data'].length).to eq(2)
  end

  it 'can get revenue within specific date range' do
    merchants = create_list(:merchant, 3)
    customers = create_list(:customer, 3)
    invoices = []
    merchants.each do |merchant|
      create_list(:item, 2, merchant_id: merchant.id)
      customers.each do |customer|
        invoices << create(:invoice, merchant_id: merchant.id, customer_id: customer.id, status: 'shipped')
      end
    end
    invoices[0..4].each { |invoice| create(:transaction, invoice_id: invoice.id, result: 'success') }
    x = 0
    invoices[0..4].each do |invoice|
      create(:invoice_item, invoice_id: invoice.id, quantity: x += 200, unit_price: 10)
    end

    get '/api/v1/revenue?start=2020-01-09&end=2020-12-24'

    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['revenue']).to eq(InvoiceItem.all.sum('quantity * unit_price'))
  end

  it 'can get revenue for one specific merchant' do
    merchants = create(:merchant)
    customers = create(:customer)
    invoice1 = create(:invoice, merchant_id: merchants.id, customer_id: customers.id, status: 'shipped')
    create(:item, merchant_id: merchants.id)
    create(:invoice_item, invoice_id: invoice1.id, quantity: 10, unit_price: 10)
    create(:transaction, invoice_id: invoice1.id, result: 'success')

    merch_id = Merchant.first.id
    get "/api/v1/merchants/#{merch_id}/revenue"

    expect(response).to be_successful

    result = JSON.parse(response.body)
    expect(result['data']['attributes']['revenue']).to eq(100.0)
  end

  it 'can create a merchant with no id passed in params' do
    first_merchant = create(:merchant)
    merchant_params = {
      name: 'George Clooney',
      created_at: '03-04-04',
      updated_at: '05-10-19'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)
    created_merchant = Merchant.last

    expect(response).to be_successful
    expect(created_merchant.id).to eq(first_merchant.id + 1)
  end

  it 'can find all merchants by their created_at' do
    Merchant.create!({
                       name: 'Hammer George',
                       created_at: '01-06-1993',
                       updated_at: '02-12-2000'
                     })

    merchant2 = Merchant.create!({
                                   name: 'George Pinky',
                                   created_at: '02-06-1980',
                                   updated_at: '04-12-2010'
                                 })

    Merchant.create!({
                       name: 'Timothy',
                       created_at: '01-06-1993',
                       updated_at: '04-12-2010'
                     })

    get '/api/v1/merchants/find_all?created_at=02-06-1980'
    expect(response).to be_successful

    result = JSON.parse(response.body)
    expect(result['data'].length).to eq(1)
    expect(result['data'].first['attributes']['id']).to eq(merchant2.id)
  end

  it 'gets an error when no params are passed through when searching for merchant by name' do
    get '/api/v1/merchants/find_all?name='

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['code']).to eq(204)
    expect(result['data']['attributes']['message']).to eq('name missing')
  end

  it 'gets 204 error when no params are passed through when searching for merchant by id' do
    get '/api/v1/merchants/find_all?id='

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['code']).to eq(204)
    expect(result['data']['attributes']['message']).to eq('id missing')
  end

  it 'gets 204 error when there is no match for one merchant' do
    get '/api/v1/merchants/find?name='

    result = JSON.parse(response.body)

    expect(result['data']['attributes']['code']).to eq(204)
    expect(result['data']['attributes']['message']).to eq('name missing')
  end
end
