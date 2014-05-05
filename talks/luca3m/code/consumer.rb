require 'redis'

r = Redis.new

puts "Start consuming.."

loop do
  message = r.brpop "queue"
  puts "Receive: #{message[1]} from queue: #{message[0]}"
end
