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
        Chartroom::Image.all
      end

      def images_include_intermediate
        Chartroom::Image.all(true)
      end

      def tagged_images
        images.select { |image| image.tagged? }
      end
    end

    get "/" do
      @info = Docker.version
      @images = tagged_images
      @containers = containers

      slim :index
    end

    get "/images" do
      @active = "images"
      @images = tagged_images

      slim :images
    end

    get "/containers" do
      @active = "containers"
      @containers = containers

      slim :containers
    end

    get "/api/images" do
      content_type :json

      tree_diagram = Chartroom::Image.generate_diagram(images_include_intermediate)

      { dot: tree_diagram }.to_json
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
