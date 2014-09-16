
# Post Class ************************************************************
class Post
	attr_reader :id
	attr_accessor :content, :timestamp

	def initialize(post_data_hash)
		@id = post_data_hash['id']
		@content = post_data_hash['content']
		@timestamp = post_data_hash['timestamp']
	end
end