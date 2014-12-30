source "https://rubygems.org"
source "https://rails-assets.org"

ruby "2.2.0"

gem "sinatra", "~> 1.4.5", require: "sinatra/base"

gem "coffee-script"
gem "sass"
gem "slim"

gem "sprockets"
gem "sprockets-helpers"

gem "rails-assets-jquery"
gem "rails-assets-bootstrap"
gem "rails-assets-bootstrap-css"
gem "rails-assets-vis"

gem "docker-api", "~> 1.15", require: "docker"

group :development, :test do
  gem "coveralls", require: false
  gem "rspec"
end

group :development do
  gem "guard-rspec"
  gem "rake"
  gem "sinatra-reloader", require: "sinatra/reloader"
  gem "terminal-notifier-guard"
end
