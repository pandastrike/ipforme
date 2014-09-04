# Date: 2014-09-02
# Author: Mike Steinfeld
# App: ipforme
# ---------------------------------------
# This little app allows us to store an IP address using Redis 
# for passing around IPs to server provisioning scripts. 
# We create the key_value via HTTP Post, delimitted by underscore ("host_4.3.3.3")
# and retreive the value by http://example.com/key
#
# Example: 
# curl -sF 'hostip=ident_4.3.3.3' http://domain/ > /dev/null
# curl http://domain/ident


require 'sinatra'
require 'redis'
require 'json'

redis = Redis.new
 
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
 
get '/' do
  erb :index
end

# \b(?:\d{1,3}\.){3}\d{1,3}\b
post '/' do 
  if params[:hostip] and not params[:hostip].empty?  # regex for ip should go here 
    if not params[:hostip] =~ /\w_\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ # ugly format validator
      not_found # 404 
    else
      @host = "#{params[:hostip]}".split('_')[0]
      @ip = "#{params[:hostip]}".split('_')[1]
      if redis.get "#{@host}"
        not_found # 404 - key has been used already
      else
        redis.setnx @host, @ip
      end
    end
    erb :index
  end
end

get '/:hostip' do
  @host = "#{params[:hostip]}"
  @ip = redis.get "#{@host}"
  content_type :json
    { :host => @host, :ip => @ip }.to_json
end

not_found do
  halt 404, 'Houston, we have a problem!'
end