require 'pry'
require 'ap'
require 'sqlite3'
require 'rack'
require 'erubis'
require 'geocoder'
require_relative 'user'
require_relative 'post'
require_relative 'orm'

# Q's for Colt
# - How to do password matching and verification?  If-Then, followed by redirect?    --> Max to show tomorrow
# - The SQL database stores keys as strings (and not symbols).  Do I have to work with strings all the time instead of symbols?  --> Yes
# - Geomapping: either ruby geocoder or google maps api 

# 2 ways

# 2nd
# rubygeocoder.com 
# gem install geocoder
# binding.pry --> request.location

# 1st
# google maps api
# requires api key 
# require 'typhoeus'
# data = Typhoes.get("url with string interpolation")
# res = JSON.parse(data.body)    <--- returns geolocation





# App ************************************************************
class App

	attr_accessor :current_user

	def initialize()
		@orm = ORM.new()
		# @users and @posts are arrays of objects
		@users = @orm.all(:users)
		@posts = @orm.all(:posts)
		@current_user = nil
		@error_message = []
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
			when '/login', '/'
				res.write render('login', {:errors => @error_message})
			when '/create'

				if request.POST['new_username'] #trying to register NEW user
					attempted_new_username = request.POST['new_username']
					username_exists = check_if_username_exists(attempted_new_username)

					if username_exists
						@error_message = ["Sorry, that username already exists. Please choose another."]
						res.write render('login', {:errors => @error_message})
					elsif request.POST['new_password'] != request.POST['confirm_password'] # passwords did not match
						@error_message = ["You did not enter the same password.  Please try again."]
						res.write render('login', {:errors => @error_message})
					else
						new_user_hash = {
							'username' => request.POST['new_username'],
							'password' => request.POST['new_password'],
							'address' => request.POST['address'],
							'city' => request.POST['city'],
							'state' => request.POST['state'],
							'country' => request.POST['country']
						}

						new_user = User.new(new_user_hash)
						@users.push(new_user)
						@orm.save_user(new_user)
						res.redirect('/index')
					end
				elsif request.POST['username'] #trying to login as EXISTING user
					@current_user = request.POST['username']
					res.redirect('/index')
				end

			when '/register_existing_username'	
				res.write render('register_existing_username')
			when '/index'
				locals = {
					:users => @users,
				}
				res.write render('index', locals)	
			end
		end
	end


	def render(file_name, locals = {})  
		path = "views/" + file_name + ".erb"
		file = File.read(path)
		Erubis::Eruby.new(file).result(locals)
	end

	def check_if_username_exists(attempted_username)
		username_exists = false
		@users.each do |user|
			if user.username == attempted_username
				username_exists = true
			end
		end
		return username_exists
	end

end


Rack::Handler::WEBrick.run App.new
