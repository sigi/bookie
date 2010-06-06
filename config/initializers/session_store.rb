# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bookie_session',
  :secret      => 'b4d255f4fd2eead0644aa6034851691bd1ce42831f6da2cf802bdf4f83017cd9d23133ee78709d710b70516a9e3f95ec5e03f441d5eb7caeba4778841f449ac6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
