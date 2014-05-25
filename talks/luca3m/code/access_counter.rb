require 'redis'
require 'sinatra'

$redis = Redis.new

template = <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>Redis Example</title>
  <style>
  h1 { font-size: 4em; text-align: center; }
  .container { width: 100%; height: 100%; margin: auto; }
  </style>
</head>
<body>
  <div class="container">
    <h1>Visitors per minute: <%= @counter %></h1>
  </div>
</body>
</html>
EOF

get "/" do
  $redis.client.call %w(SET access_control 0 EX 60 NX)
  @counter = $redis.incr "access_control"
  erb template
end
