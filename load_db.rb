require 'sqlite3'

def load_db_tables()
	database = SQLite3::Database.new 'social_network.db'

	database.execute('PRAGMA foreign_keys = ON;')

	database.execute_batch <<-SQL
		CREATE TABLE users (
			id INTEGER PRIMARY KEY,
			username VARCHAR(255),
			password VARCHAR(255),
			address VARCHAR(255),
			city VARCHAR(255),
			state VARCHAR(255),
			country VARCHAR(255),
			geolocation VARCHAR(255)
		);

		CREATE TABLE posts (
			id INTEGER PRIMARY KEY,
			content VARCHAR(255),
			timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
		);

		CREATE TABLE user_posts (
			post_id INTEGER,
			user_id INTEGER,
			FOREIGN KEY (post_id) REFERENCES post(id),
			FOREIGN KEY (user_id) REFERENCES user(id)
		);
		
		CREATE TABLE friends (
			id INTEGER,
			friend_name VARCHAR(255),
			FOREIGN KEY (id) REFERENCES user(id),
			FOREIGN KEY (friend_name) REFERENCES user(username)
		);
	SQL

	# Start with a single user in the database
	database.execute <<-SQL
		INSERT INTO users 
			(username, password, address, city, state, country)
		VALUES 
			("dstockalper", 8184, "1000 Foster City Blvd", "Foster City", "CA", "United States")
		;
	SQL

end

load_db_tables()