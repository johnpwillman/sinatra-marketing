require 'bundler'

require 'sinatra'

require 'json'

require 'data_mapper'
require 'dm-timestamps'

Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:test.sqlite3')

class Resource
  include DataMapper::Resource

  property :id,     Serial
  property :value,  String, :length => 128
end

# Tell DataMapper the models are done being defined
DataMapper.finalize
#New schema
Resource.auto_upgrade!

# helpers ######################################################################
helpers do
  def protected!
    response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
    throw(:halt, [401, "Not authorized\n"])
  end

  def authorized?
    user, pass = ENV['SITE_USER'], ENV['SITE_PASS']
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials &&
    @auth.credentials == [user, pass]
  end

  def json_body
    @json_body || (body = request.body.read && JSON.parse(body))
  end

  def show_request
    body = request.body.read
    unless body.empty?
      STDOUT.puts "request body:"
      STDOUT.puts(@json_body = JSON.parse(body))
    end
    unless params.empty?
      STDOUT.puts "params: #{params.inspect}"
    end
  end
end
################################################################################

get '/' do
  erb :index
end

get '/:id' do
  show_request
  # protected! unless authorized?

  @params = params
end
