require 'redis'

r = Redis.new
name = ARGV[0]

loop do
  msgid = r.incr "msgid"
  msg = "hello #{msgid}, by #{name}"
  r.lpush "queue", msg
  puts "Produced: #{msg}"
  sleep 0.1
end
