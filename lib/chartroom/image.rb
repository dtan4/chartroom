module Chartroom
  class Image
    class << self
      def all(include_intermediate = false)
        Docker::Image.all(all: include_intermediate).map { |image| self.new(image) }
      end

      def generate_diagram(images)
        root_images = []
        by_parent = {}

        images.each do |image|
          if image.parent_id == ""
            root_images << image
          else
            by_parent[image.parent_id] ||= []
            by_parent[image.parent_id] << image
          end
        end

        root_images.inject([]) do |tree, image|
          tree << walk_tree(image, by_parent)
        end.map { |image| image.to_hash }
      end

      private

      def walk_tree(image, by_parent)
        by_parent[image.id].each do |child|
          image.children << walk_tree(child, by_parent) if by_parent[child.id] || child.tagged?
        end if by_parent[image.id]

        image
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
      (repo_tags.size >= 1) && (repo_tags.first != "<none>:<none>")
    end

    def children
      @children ||= []
    end

    def to_hash
      { id: id, name: name, tagged: tagged?, children: children.map { |child| child.to_hash } }
    end

    private

    def name
      tagged? ? repo_tags.join(", ") : short_id
    end
  end
end
