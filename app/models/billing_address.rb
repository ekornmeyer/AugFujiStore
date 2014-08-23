class BillingAddress < ActiveRecord::Base
	belongs_to :customer
	validates :bi_address1, presence: true
	validates :bi_address2, presence: true
	validates :bi_city, presence: true
	validates :bi_state, presence: true
	validates :bi_zipcode, presence: true

	def bi_full_address
		"#{bi_address1} #{bi_address2}, #{bi_city}, #{bi_state} #{bi_zipcode}"
	end	
end
