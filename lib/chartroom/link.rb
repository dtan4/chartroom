module Chartroom
  class Link
    def initialize(link)
      @link = link
      link_name, link_alias = *@link.split(":")
      @link_name = link_name.gsub("/", "")
      @link_alias = link_alias.gsub(/\/.+\//, "")
    end

    def link_name
      @link_name
    end

    def link_alias
      @link_alias
    end

    def prettify
      "#{link_name}:#{link_alias}"
    end
  end
end
