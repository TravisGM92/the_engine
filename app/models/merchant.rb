class Merchant < ApplicationRecord
  has_many :items
  validates_presence_of :name, :created_at, :updated_at

  def self.downcase_split_names(name)
    name.downcase.split(" ")
  end
end
