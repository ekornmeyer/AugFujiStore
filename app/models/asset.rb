class Asset < ActiveRecord::Base
	belongs_to :customer
	validates :file_name, presence: true
	validates :customer_id, presence: true
	mount_uploader :file_name, AssetUploader
end