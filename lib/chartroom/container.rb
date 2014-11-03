module Chartroom
  class Container
    def self.generate_diagram(containers)
      diagram_description = []

      containers.each do |container|
        diagram_description << container.node_description

        container.links.each do |link|
          destination_name = link.split(":")[0][1..-1]
          destination_id = self.find_destination_id(destination_name, containers)
          diagram_description << "container_#{container.id} -> container_#{destination_id};"
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

    def initialize(container)
      @container = container
    end

    def id
      @id ||= @container.info["id"]
    end

    def names
      @names ||= @container.info["Names"].map { |name| name.sub(/\A\//, "") }
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

    def node_description
      "container_#{id}[label=\"#{names.join("\n")}\"];"
    end

    def link_description
      link_description = []

      links.each do |link|
        link_description << "image_#{id}"
      end
    end

    private

    def self.find_destination_id(destination_name, containers)
      destination = containers.select { | container| container.names.include?(destination_name) }.first

      destination ? destination.id : ""
    end
  end
end
