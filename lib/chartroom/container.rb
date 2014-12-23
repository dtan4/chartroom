module Chartroom
  class Container
    class << self
      def generate_diagram(containers)
        diagram_description = []

        containers.each do |container|
          diagram_description << container.node_description

          # TODO: separate method
          container.links.each do |link|
            destination_id = self.find_destination_id(link.link_name, containers)
            diagram_description << "container_#{container.id} -> container_#{destination_id};" if destination_id
          end

          diagram_description.concat container.ports_description
        end

      <<-DIAGRAM
strict digraph containers {
rankdir=BT;
node[style=filled];

#{diagram_description.join("\n")}
}
      DIAGRAM
      end

      def all
        Docker::Container.all.map { |container| self.new(container) }
      end
    end

    def initialize(container)
      @container = container
    end

    def id
      @id ||= @container.info["id"]
    end

    def short_id
      id[0..11]
    end

    def name
      @name ||= @container.json["Name"].sub(/\A\//, "")
    end

    def image
      @image ||= @container.info["Image"]
    end

    def command
      @command ||= @container.info["Command"]
    end

    def links
      @links ||= (@container.json["HostConfig"]["Links"] || []).map { |link| Chartroom::Link.new(link) }
    end

    def formatted_links
      @formatted_links ||= links.map { |link| link.prettify }.join(", ")
    end

    def ports
      @port ||= @container.info["Ports"].select { |port| !port["PublicPort"].nil? }
    end

    def formatted_ports
      @formatted_ports ||=
        ports.map { |port| "#{port['PrivatePort']} -> #{port['PublicPort']} (#{port['Type'].upcase})" }.join(", ")
    end

    def status
      @container.info["Status"]
    end

    def node_description
      "container_#{id}[label=\"#{name}\", shape=box];"
    end

    def ports_description
      ports_description = []
      port_nodes = []

      ports.each do |port|
        public_port, private_port = port["PublicPort"], port["PrivatePort"]
        ports_description << "container_#{id} -> port_#{public_port} [label=\"#{public_port} -> #{private_port}\"];"
        port_nodes << "port_#{public_port}[color=lawngreen, label=\"#{public_port}\", shape=ellipse];"
      end

      ports_description.concat port_nodes.uniq
    end

    private

    def self.find_destination_id(destination_name, containers)
      destination = containers.select { | container| container.name == destination_name }.first

      destination ? destination.id : nil
    end
  end
end
