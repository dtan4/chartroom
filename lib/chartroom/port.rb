module Chartroom
  class Port
    def initialize(port)
      @port = port
    end

    def private_port
      @private_port ||= @port["PrivatePort"]
    end

    def public_port
      @public_port ||= @port["PublicPort"]
    end

    def type
      @type ||= @port['Type']
    end

    def prettify
      "#{link_name}:#{link_alias}"
    end
  end
end
