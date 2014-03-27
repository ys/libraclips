source "https://rubygems.org"

ruby "2.1.1"

gem "rake"
gem "scrolls"
gem "faraday"
gem "pg"
gem "sequel"

group :web do
  gem "unicorn"
  gem "sinatra"
  gem "sinatra-contrib"
end

group :development do
  gem "dotenv"
  gem "debugger"
  gem "pry"
  gem "foreman"
end

group :test do
  gem "vcr"
  gem "webmock"
  gem "rack-test"
  gem "simplecov", require: false
end
