require 'optparse'
require 'uri'
require 'net/http'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: add_comment.rb [options]"

  opts.on('-t', '--text=TEXT', 'Text of the comment to add to the tracker story') do |text|
    options[:text] = text
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end.parse!

raise OptionParser::MissingArgument.new("--text [text] option missing") if options[:text].nil?
url = URI("https://www.pivotaltracker.com/services/v5/projects/#{ENV[:TRACKER_ID]}/stories/#{ENV[:STORY_ID]}/comments")

http = Net::HTTP.new(url.host, url.port)

request = Net::HTTP::Post.new(url)
request["X-TrackerToken"] = ENV[:TRACKER_API_KEY]
request["Content-Type"] = 'application/json'
request.body = "{\"text\":\"#{options[:text]}\"}"

response = http.request(request)
