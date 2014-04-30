require 'redis'

redis = Redis.new

@new_array = ["#{redis.hgetall 1}", "#{redis.hgetall 2}"] 