module Chartroom
  class Image
    class << self
      def generate_diagram(images)
        images_description = []

        images.select { |image| image.tagged? }.each do |image|
          current_image = image
          parent_images = ["image_#{current_image.id}"]

          loop do
            images_description << current_image.node_description

            break if current_image.parent_id == ""
            next_image = images.select { |_image| _image.id == current_image.parent_id }.first
            parent_images << "image_#{next_image.id}"
            break if next_image.tagged?

            current_image = next_image
          end

          images_description << "#{parent_images.join(" -> ")};"
        end

      <<-DIAGRAM
strict digraph images {
rankdir=BT;
node[style=filled];

#{images_description.join("\n")}
}
      DIAGRAM
      end

      def all(include_intermediate = false)
        Docker::Image.all(all: include_intermediate).map { |image| self.new(image) }
      end
    end

    def initialize(image)
      @image = image
    end

    def id
      @id ||= @image.info["id"]
    end

    def short_id
      id[0..11]
    end

    def repo_tags
      @repo_tags ||= @image.info["RepoTags"]
    end

    def virtual_size
      @virtual_size ||= @image.info["VirtualSize"]
    end

    def created_at
      @created_at ||= @image.info["Created"]
    end

    def parent_id
      @parent_id ||= @image.info["ParentId"]
    end

    def short_parent_id
      parent_id[0..11]
    end

    def tagged?
      (repo_tags.size > 1) || (repo_tags.first != "<none>:<none>")
    end

    def node_description
      "image_#{id}[color=#{node_color}, label=\"#{node_label}\", shape=#{node_shape}];"
    end

    private

    def node_color
      tagged? ? "lawngreen" : "lightgray"
    end

    def node_label
      tagged? ? repo_tags.join("\n") : short_id
    end

    def node_shape
      tagged? ? "box" : "ellipse"
    end
  end
end
