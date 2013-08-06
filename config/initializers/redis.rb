require 'redis'

$redis = if Rails.env.production?
           uri = URI.parse(ENV["REDISCLOUD_URL"])
           Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
         else
           Redis.new
         end
