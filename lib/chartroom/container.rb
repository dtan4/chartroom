module Chartroom
  class Container
    def initialize(container)
      @container = container
    end

    def id
      @id ||= @container.info["id"]
    end

    def names
      @names ||= @container.info["Names"]
    end

    def image
      @image ||= @container.info["Image"]
    end

    def command
      @command ||= @container.info["Command"]
    end

    def links
      @links ||= (@container.json["HostConfig"]["Links"] || [])
    end

    def status
      @container.json["Status"]
    end
  end
end
