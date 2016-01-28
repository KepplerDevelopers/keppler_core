class Property < ActiveRecord::Base
	belongs_to :google_analytic
	validates_presence_of :name

	def code_random
		SecureRandom.hex(4)
	end
end
