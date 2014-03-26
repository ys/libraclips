source "https://rubygems.org"

ruby "2.1.1"

gem "dotenv"
gem "rake"
gem "scrolls"
gem "faraday"
gem "pg"
gem "sequel"

group :web do
  gem "unicorn"
  gem "sinatra", require: "sinatra/base"
end

group :development do
  gem "debugger"
  gem "pry"
  gem "foreman"
end

group :test do
  gem "vcr"
  gem "webmock"
end
