require "bundler"
Bundler.require

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "chartroom"

map "/assets" do
  run Chartroom::App.assets
end

run Chartroom::App
