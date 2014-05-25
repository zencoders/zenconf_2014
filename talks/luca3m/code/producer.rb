require 'redis'

r = Redis.new
name = ARGV[0]
msgid=0

loop do
  # Compose message
  msg = "hello #{msgid} by #{name}"
  msgid+=1

  # Publish it
  r.lpush "queue", msg

  puts "Produced: #{msg}"
  sleep 0.1
end
