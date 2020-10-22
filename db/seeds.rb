# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
# require './app/models/customer'
# require './app/models/invoice_item'
# require './app/models/invoice'
# require './app/models/item'
# require './app/models/merchant'
# require './app/models/transaction'

InvoiceItem.delete_all
InvoiceItem.reset_pk_sequence
Item.delete_all
Item.reset_pk_sequence
Transaction.delete_all
Transaction.reset_pk_sequence
Invoice.delete_all
Invoice.reset_pk_sequence
Merchant.delete_all
Merchant.reset_pk_sequence
Customer.delete_all
Customer.reset_pk_sequence
# tables = ['merchants', 'customers', 'items', 'invoices', 'transactions', 'invoice_items']

CSV.foreach('db/data/customers.csv', headers: true) do |row|
  Customer.create!({
                     first_name: row['first_name'],
                     last_name: row['last_name'],
                     created_at: row['created_at'],
                     updated_at: row['updated_at']
                   })
end

CSV.foreach('db/data/merchants.csv', headers: true) do |row|
  Merchant.create!({
                     name: row['name'],
                     created_at: row['created_at'],
                     updated_at: row['updated_at']
                   })
end

CSV.foreach('db/data/items.csv', headers: true) do |row|
  Item.create!({
                 name: row['name'],
                 description: row['description'],
                 unit_price: ((row['unit_price']).to_f / 100),
                 merchant_id: row['merchant_id'],
                 created_at: row['created_at'],
                 updated_at: row['updated_at']
               })
end

CSV.foreach('db/data/invoices.csv', headers: true) do |row|
  Invoice.create!({
                    customer_id: row['customer_id'],
                    merchant_id: row['merchant_id'],
                    status: row['status'],
                    created_at: row['created_at'],
                    updated_at: row['updated_at']
                  })
end

CSV.foreach('db/data/invoice_items.csv', headers: true) do |row|
  InvoiceItem.create!({
                        item_id: row['item_id'],
                        invoice_id: row['invoice_id'],
                        quantity: row['quantity'],
                        unit_price: (row['unit_price'].to_f / 100),
                        created_at: row['created_at'],
                        updated_at: row['updated_at']
                      })
end

CSV.foreach('db/data/transactions.csv', headers: true) do |row|
  Transaction.create!({
                        invoice_id: row['invoice_id'],
                        credit_card_number: row['credit_card_number'],
                        credit_card_expiration_date: row['credit_card_expiration_date'],
                        result: row['result'],
                        created_at: row['created_at'],
                        updated_at: row['updated_at']
                      })
end
