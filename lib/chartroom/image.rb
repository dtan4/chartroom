module Chartroom
  class Image
    %i(id repo_tags virtual_size created_at parent_id).each do |attr|
      attr_reader attr
    end

    def initialize(image_info)
      @id = image_info["id"]
      @repo_tags = image_info["RepoTags"]
      @virtual_size = image_info["VirtualSize"]
      @created_at = image_info["Created"]
      @parent_id = image_info["ParentId"]
    end

    def tagged?
      (@repo_tags.size > 1) || (@repo_tags.first != "<none>:<none>")
    end

    def row_class
      tagged? ? "success" : ""
    end
  end
end
