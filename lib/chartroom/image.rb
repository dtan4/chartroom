module Chartroom
  class Image
    def initialize(image)
      @image = image
    end

    def id
      @id ||= @image.info["id"]
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

    def tagged?
      (repo_tags.size > 1) || (repo_tags.first != "<none>:<none>")
    end

    def row_class
      tagged? ? "success" : ""
    end
  end
end
