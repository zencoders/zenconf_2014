require 'redis'
require 'sinatra'

$redis = Redis.new

get "/" do
  replies = $redis.pipelined do
    $redis.client.call %w(SET access_control 0 EX 60 NX)
    $redis.incr "access_control"
  end
  @counter = replies[1]
  erb :index
end
