require 'sinatra'
require 'rest-client'
require 'nokogiri'

get '/' do
  # This super naive proxying doesn't pass through error codes or headers
  content = RestClient.get('localhost:4567/example_dynamic_page')
  # Strip script tags
  doc = Nokogiri.HTML(content)
  doc.search('script').remove
  doc.to_s
end

# An example dynamic page that can be used to demonstrate the
# proxy. This page is a simple page that gets loaded via javascript
# (in this case React).
get '/example_dynamic_page' do
  haml :example_dynamic_page
end
