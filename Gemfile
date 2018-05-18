source 'https://rubygems.org'

ruby '2.4.1'

gem 'puma', '~> 3'
gem 'sinatra', '~> 2'
gem 'json'

gem 'data_mapper', '~> 1.2'
gem 'dm-timestamps'

group :development do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'pg'
end
