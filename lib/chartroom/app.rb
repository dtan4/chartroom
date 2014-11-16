module Chartroom
  class App < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "app"))
    set :assets, Sprockets::Environment.new(root)

    configure do
      RailsAssets.load_paths.each do |path|
        assets.append_path(path)
      end

      assets.append_path File.join(root, "assets", "stylesheets")
      assets.append_path File.join(root, "assets", "javascripts")

      Sprockets::Helpers.configure do |config|
        config.environment = assets
        config.prefix = "/assets"
        config.digest = true
      end
    end

    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
    end

    helpers do
      include Sprockets::Helpers
    end

    get "/" do
      slim :index
    end

    get "/images" do
      @images = Docker::Image.all.map { |image| Chartroom::Image.new(image) }.select { |image| image.tagged? }

      slim :images
    end

    get "/api/images" do
      content_type :json

      images = Docker::Image.all(all: "1").map { |image| Chartroom::Image.new(image) }
      tree_diagram = Chartroom::Image.generate_diagram(images)

      { dot: tree_diagram }.to_json
    end

    get "/containers" do
      @containers = Docker::Container.all.map { |container| Chartroom::Container.new(container) }

      slim :containers
    end

    get "/api/containers" do
      content_type :json

      containers = Docker::Container.all.map { |container| Chartroom::Container.new(container) }
      diagram = Chartroom::Container.generate_diagram(containers)

      { dot: diagram }.to_json
    end
  end
end
