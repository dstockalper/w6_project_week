require 'pry'
require 'ap'
require 'sqlite3'
require 'rack'
require 'erubis'

# User ************************************************************
class User
	attr_reader :id
	attr_accessor :name, :password, :address, :geolocation

	def initiallize(user_data_hash)
		@id = user_data_hash['id']
		@username = user_data_hash['username']
		@password = user_data_hash['password']
		@address = user_data_hash['address']
	end
end

# Post ************************************************************
class Post
	attr_reader :id
	attr_accessor :content, :timestamp

	def initialize(post_data_hash)
		@id = post_data_hash['id']
		@content = post_data_hash['content']
		@timestamp = post_data_hash['timestamp']
	end
end

# ORM ************************************************************
class ORM

	TABLE_CLASS_MAP = {
		:users => User,
		:posts => Post
	}


	def initialize()
		@db = SQLite3::Database.new('social_network.db')
		@db.results_as_hash = true
	end


	def db_rows_into_objects(table_symbol)
		results = @db.execute("select * from #{table_symbol}")

		results.map do |table_row|
			model = TABLE_CLASS_MAP[table_symbol]
			model.new(table_row)
		end
	end


	def save_user(user_object)
		@db.execute <<-SQL, [user.username, user.id]
			UPDATE users SET
				username = ?
			WHERE
				id = ?
		SQL
	end

end

# App ************************************************************
class App

	def initialize()
		
	end
	
	def call(env)
		ap env

		request = Rack::Request.new(env)
		response = handle_request(request)
		return response.finish()
	end


	def handle_request(request)
		Rack::Response.new do |res|
			case request.path_info
			when '/index'
				res.write render('index')
			end
		end
	end


	def render(file_name, locals = {})  
		path = "views/" + file_name + ".erb"
		file = File.read(path)
		Erubis::Eruby.new(file).result(locals)
	end

end


Rack::Handler::WEBrick.run App.new
