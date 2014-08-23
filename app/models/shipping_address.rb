class ShippingAddress < ActiveRecord::Base
	belongs_to :customer	
	validates :sh_address1, presence: true
	validates :sh_address2, presence: true
	validates :sh_city, presence: true
	validates :sh_state, presence: true
	validates :sh_zipcode, presence: true	

	def sh_full_address
		"#{sh_address1} #{sh_address2}, #{sh_city}, #{sh_state} #{sh_zipcode}"
	end
end
