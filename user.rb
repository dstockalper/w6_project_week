# User Class ************************************************************
class User
	attr_reader :id
	attr_accessor :username, :password, :address, :city, :state, :country, :geolocation

	def initialize(user_data_hash)
		@id = user_data_hash['id']
		@username = user_data_hash['username']
		@password = user_data_hash['password']
		@address = user_data_hash['address']
		@city = user_data_hash['city']
		@state = user_data_hash['state']
		@country = user_data_hash['country']
	end
end
