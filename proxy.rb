require 'sinatra'
require 'nokogiri'
require 'phantomjs'

# Will also install phantomjs if it's not already there
Phantomjs.path

get '/proxy' do
  url = params['url'] || 'http://localhost:4567/example_dynamic_page'

  # This super naive proxying doesn't pass through error codes or headers
  content = Phantomjs.run('./phantomjs/get.js', url)
  # Strip script tags
  doc = Nokogiri.HTML(content)
  doc.search('script').remove
  # Rewrite image urls to absolute urls
  # And what madness. Also escaping url for cases for where
  # people are including unescaped urls
  doc.search('img').each do |img|
    img['src'] = URI(url) + URI.escape(img['src'])
  end
  # Rewrite css urls to absolute urls
  doc.search('link').each do |link|
    link['href'] = URI(url) + URI.escape(link['href'])
  end
  doc.to_s
end

# An example dynamic page that can be used to demonstrate the
# proxy. This page is a simple page that gets loaded via javascript
# (in this case React).
get '/example_dynamic_page' do
  haml :example_dynamic_page
end
