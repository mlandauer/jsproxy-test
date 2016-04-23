require 'sinatra'
require 'rest-client'

get '/' do
  # This super naive proxying doesn't pass through error codes or headers
  RestClient.get('localhost:4567/example_dynamic_page')
end

# An example dynamic page that can be used to demonstrate the
# proxy. This page is a simple page that gets loaded via javascript
# (in this case React).
get '/example_dynamic_page' do
  haml :example_dynamic_page
end
