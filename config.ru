require 'sprockets'
require 'rack'
require 'rack/contrib/try_static'

map '/js' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  environment.append_path 'public/javascripts'

  run environment
end

use Rack::TryStatic,
  root: "public",
  urls: %w[/],
  try:  %w[.html index.html /index.html]

run lambda{ |env| [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ] }
