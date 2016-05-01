require 'sinatra'
require 'nokogiri'
require 'phantomjs'

# Rewrite urls to absolute urls
# And what madness. Also escaping url for cases for where
# people are including unescaped urls
# N.B. modifies doc
def convert_to_absolute_urls!(doc, url, selector, attribute)
  doc.search(selector).each do |node|
    if node[attribute]
      node[attribute] = url + URI.escape(node[attribute])
    end
  end
end

# In a given bit of text which is css convert all urls
# to be absolute
def in_css_make_urls_absolute(css, base_url)
  css.gsub(/url\(([^\)]*)\)/) do |c|
    begin
      url = base_url + $1
    rescue
      # If we can't interpret this as a url just leave it be
      $1
    end
    "url(#{url})"
  end
end

def html_base_url(doc, url)
  if doc.at('head base')
    url + doc.at('head base')['href']
  else
    url
  end
end

def phantom_get(url)
  # If there are any error messages in the console then
  # they are returned first. The last thing returned is the html
  # so look for that and then call everything above the console
  # output
  r = Phantomjs.run('./phantomjs/get.js', url.to_s)
  s = r.split("**jksdhljasdhjwb**")
  {console: s[0], html: s[1]}
end

def process_html(content, url)
  # Strip script tags
  doc = Nokogiri.HTML(content)
  base_url = html_base_url(doc, url)
  doc.search('script').remove
  convert_to_absolute_urls!(doc, base_url, 'img', 'src')
  convert_to_absolute_urls!(doc, base_url, 'link', 'href')
  convert_to_absolute_urls!(doc, base_url, 'a', 'href')
  # Rewrite links to point at the proxy
  doc.search('a').each do |node|
    if node['href']
      node['href'] = "/proxy?url=" + CGI.escape(node['href'])
    end
  end
  # Find all embedded css in style attributes
  doc.search('*[style]').each do |node|
    node['style'] = in_css_make_urls_absolute(node['style'], base_url)
  end
  doc.search('style').each do |node|
    node.content = in_css_make_urls_absolute(node.content, base_url)
  end
  doc.to_s
end

# Will also install phantomjs if it's not already there
Phantomjs.path

get '/proxy' do
  default_url = "http://#{request.env['HTTP_HOST']}/example_dynamic_page"
  url = URI(params['url'] || default_url)

  # This super naive proxying doesn't pass through error codes or headers
  result = phantom_get(url)
  content = process_html(result[:html], url)
  # Now inject some javascript so that it spits out the console output from
  # phantomjs in the console
  doc = Nokogiri.HTML(content)
  script_node = Nokogiri::XML::Node.new('script', doc)
  script_node.content = result[:console].split("\n").map{|l| "console.log(\"from phantomjs: #{l}\")"}.join("\n")
  doc.at('head').add_child(script_node)
  doc.to_s
end

# An example dynamic page that can be used to demonstrate the
# proxy. This page is a simple page that gets loaded via javascript
# (in this case React).
get '/example_dynamic_page' do
  haml :example_dynamic_page
end
