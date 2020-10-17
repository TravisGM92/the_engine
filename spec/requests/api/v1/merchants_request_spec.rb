require 'rails_helper'

describe "Items API" do
  it "sends a list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)

      expect(merchant).to have_key(:created_at)
      expect(merchant[:created_at]).to be_a(String)

      expect(merchant).to have_key(:updated_at)
      expect(merchant[:updated_at]).to be_a(String)
    end
  end

  it "can send one merchant" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)

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
      created_at: '03-04-04',
      updated_at: '05-10-19'
      })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)
      created_merchant = Merchant.last

      expect(response).to be_successful
      expect(created_merchant.name).to eq(merchant_params[:name])
      expect(created_merchant.created_at).to eq(merchant_params[:created_at])
      expect(created_merchant.updated_at).to eq(merchant_params[:updated_at])
  end

  it "can update a merchant" do
    id = create(:merchant).id

    previous_name = Merchant.last.name

    merchant_params = { updated_at: '10-10-20' }
    headers = {'CONTENT_TYPE' => 'application/json'}

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.updated_at).to_not eq('05-10-19')
    expect(merchant.updated_at).to eq('10-10-20')
  end

  it "can destroy an existing record" do
    merchant = create(:merchant)
    expect(Merchant.count).to eq(1)

    expect{ delete "/api/v1/merchants/#{merchant.id}"}.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

end
