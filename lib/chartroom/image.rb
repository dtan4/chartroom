module Chartroom
  class Image
    def self.generate_tree_diagram(images)
      images_description = images.map { |image| image.diagram_description }.join("\n")

      <<-DIAGRAM
digraph images {
#{images_description}
}
      DIAGRAM
    end

    def initialize(image)
      @image = image
    end

    def id
      @id ||= @image.info["id"][0..11]
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
      @parent_id ||= @image.info["ParentId"][0..11]
    end

    def tagged?
      (repo_tags.size > 1) || (repo_tags.first != "<none>:<none>")
    end

    def row_class
      tagged? ? "success" : ""
    end

    def diagram_description
      <<-DESC
#{node_description}
#{link_description}
      DESC
    end

    private

    def node_description
      "image_#{id}[label=\"#{node_label}\", shape=#{node_shape}];"
    end

    def link_description
      parent_id == "" ? "" : "image_#{id} -> image_#{parent_id};"
    end

    def node_label
      tagged? ? repo_tags.join("\n") : id
    end

    def node_shape
      tagged? ? "box" : "ellipse"
    end
  end
end
