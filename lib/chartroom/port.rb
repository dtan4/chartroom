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
      @type ||= @port["Type"]
    end

    def prettify
      "#{private_port} -> #{public_port} (#{type.upcase})"
    end

    def edge_description(id)
      "container_#{id} -> port_#{public_port} [label=\"#{private_port} -> #{public_port}\"];"
    end

    def node_description
      "port_#{public_port}[color=lawngreen, label=\"#{public_port}\", shape=ellipse];"
    end
  end
end
