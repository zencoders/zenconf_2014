require 'redis'

r = Redis.new

puts "Start consuming.."

loop do
  queue, message = r.brpop "queue"
  puts "Received: #{message}"
end
