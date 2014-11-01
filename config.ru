require "bundler"
Bundler.require

require "./app.rb"

map "/assets" do
  run App.assets
end

run App
