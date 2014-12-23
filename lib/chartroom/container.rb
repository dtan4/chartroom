module Chartroom
  class Container
    class << self
      def generate_diagram(containers)
        diagram_description = []

        containers.each do |container|
          diagram_description << container.node_description

          container.links.each do |link|
            destination_name = link.split(":")[0][1..-1]
            destination_id = self.find_destination_id(destination_name, containers)

            unless destination_id.nil?
              diagram_description << "container_#{container.id} -> container_#{destination_id};"
            end
          end
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
      @links ||= (@container.json["HostConfig"]["Links"] || [])
    end

    def formatted_links
      @formatted_links ||= links.join(", ")
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
      "container_#{id}[label=\"#{name}\"];"
    end

    def link_description
      link_description = []

      links.each do |link|
        link_description << "image_#{short_id}"
      end
    end

    private

    def self.find_destination_id(destination_name, containers)
      destination = containers.select { | container| container.name == destination_name }.first

      destination ? destination.id : nil
    end
  end
end
