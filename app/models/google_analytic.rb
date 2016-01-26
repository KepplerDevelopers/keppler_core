class GoogleAnalytic < ActiveRecord::Base
	belongs_to :setting
	has_many :properties
end
