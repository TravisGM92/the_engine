require 'rails_helper'

describe "Items API" do
  it "sends a list of merchants" do
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

  it "can send one merchant" do
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

  it "can create a mechant" do
    merchant_params = ({
      name: 'George Clooney',
      id: '3',
      created_at: '03-04-04',
      updated_at: '05-10-19'
      })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant_params)
      created_merchant = Merchant.last

      expect(response).to be_successful
      expect(created_merchant.name).to eq(merchant_params[:name])
      expect(created_merchant.created_at).to eq(merchant_params[:created_at])
      expect(created_merchant.updated_at).to eq(merchant_params[:updated_at])
  end

  it "can update a merchant" do
    id = create(:merchant).id

    previous_name = Merchant.last.name

    merchant_params = { updated_at: '2020-10-19' }
    headers = {'CONTENT_TYPE' => 'application/json'}

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
    merchant = Merchant.find_by(id: id)
    expect(response).to be_successful
    expect(merchant.updated_at).to_not eq('05-10-19')
    expect(merchant.updated_at).to eq('2020-10-19')
  end

  it "can destroy an existing record" do
    merchant = create(:merchant)
    expect(Merchant.count).to eq(1)

    expect{ delete "/api/v1/merchants/#{merchant.id}"}.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can show all items related to that specific merchant" do
    merchants = create_list(:merchant, 2)
    expect(Merchant.count).to eq(2)

    item_params = ({
      name: 'The hammer',
      id: 2,
      description: 'Nice to hit things with',
      unit_price: 3,
      merchant_id: merchants[0].id,
      created_at: '01-06-1993',
      updated_at: '02-12-2000'
      })
    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/items", headers: headers, params: JSON.generate(item_params)

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

  it "can find multiple merchants that fit the name" do
    merchant1 = Merchant.create!({
      name: 'Hammer George',
      created_at: '01-06-1993',
      updated_at: '02-12-2000'
      })

    merchant2 = Merchant.create!({
      name: 'George Pinky',
      created_at: '02-06-1980',
      updated_at: '04-12-2010'
      })

    merchant3 = Merchant.create!({
      name: 'Timothy',
      created_at: '01-06-1993',
      updated_at: '04-12-2010'
      })

    get "/api/v1/merchants/find_all?name=orge"
    expect(response).to be_successful

    result = JSON.parse(response.body)

    expect(result['data'].length).to eq(2)
  end
end
