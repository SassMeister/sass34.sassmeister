require "bundler/setup"

require 'rack/contrib'
require 'rack-cache'
require 'dalli'
require 'memcachier'

require 'sassmeister'

# Gzip responses
use Rack::Deflater


if ENV['RACK_ENV'] == 'production'
  if memcachier_servers = ENV['MEMCACHIER_SERVERS']
    cache = Dalli::Client.new memcachier_servers.split(','), {
      username: ENV['MEMCACHIER_USERNAME'],
      password: ENV['MEMCACHIER_PASSWORD']
    }
    use Rack::Cache, verbose: true, metastore: cache, entitystore: cache
  end

else
  use Rack::Cache,
    verbose: true,
    metastore:   'memcached://localhost:11211',
    entitystore: 'memcached://localhost:11211'
end


# Run the application
run SassMeisterApp
