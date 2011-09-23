# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sunny_session',
  :secret      => '723b6ad4190a57086a022afd253e0c021049796fe63a07d914003b99fe7451b26187d77dce5c51e203cc3659b0afa3ed71d0debb9021ffbf273181e5f380fd87'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
