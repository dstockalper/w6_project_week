require_relative 'sql_statements'

# ORM Class ************************************************************
class ORM

	TABLE_CLASS_MAP = {
		:users => User,
		:posts => Post
	}


	def initialize()
		@db = SQLite3::Database.new('social_network.db')
		@db.results_as_hash = true
	end


	def all(table_symbol) # returns all rows from db into an array of objects
		# get array of hashes
		results = @db.execute("select * from #{table_symbol}")

		results.map do |row|
			model = TABLE_CLASS_MAP[table_symbol]
			model.new(row)
		end
	end


	def save_user(user_object)
		@db.execute <<-SQL, [user_object.username, user_object.password, user_object.address, user_object.city, user_object.state, user_object.country]
			INSERT INTO users 
				(username, password, address, city, state, country)
			VALUES
				(?, ?, ?, ?, ?, ?)
	
		SQL
	end



end