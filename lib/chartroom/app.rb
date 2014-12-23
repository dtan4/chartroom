module Chartroom
  class App < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "app"))
    set :assets, Sprockets::Environment.new(root)
    enable :logging

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

      def containers
        Chartroom::Container.all
      end

      def images
        Docker::Image.all.map { |image| Chartroom::Image.new(image) }
      end

      def tagged_images
        images.select { |image| image.tagged? }
      end
    end

    get "/" do
      @images = tagged_images
      @containers = containers

      slim :index
    end

    get "/images" do
      @images = tagged_images

      slim :images
    end

    get "/api/images" do
      content_type :json

      images = Docker::Image.all(all: "1").map { |image| Chartroom::Image.new(image) }
      tree_diagram = Chartroom::Image.generate_diagram(images)

      { dot: tree_diagram }.to_json
    end

    get "/containers" do
      @containers = containers

      slim :containers
    end

    get "/api/containers" do
      content_type :json

      diagram = Chartroom::Container.generate_diagram(containers)

      { dot: diagram }.to_json
    end

    delete "/api/containers/:id" do
      content_type :json

      begin
        container = Docker::Container.get(params[:id])
        container.stop

        { error: false }.to_json

      rescue Docker::Error::NotFoundError => e
        status 404

        { error: true, message: e.message }.to_json
      end
    end
  end
end
