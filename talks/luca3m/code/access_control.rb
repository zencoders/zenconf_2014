require 'redis'

r = Redis.new

replies = r.pipelined do
  r.client.call %w(SET access_control 0 EX 60 NX)
  r.incr "access_control"
end

counter = replies[1]

if counter <= 5
  puts "Access granted"
else
  puts "Resource busy, try later"
end
