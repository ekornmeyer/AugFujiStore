class Relationship < ActiveRecord::Base
  belongs_to :customer, class_name: "Customer"
  belongs_to :asset, class_name: "Customer"
  validates :customer_id, presence: true
  validates :asset_id, presence: true
end