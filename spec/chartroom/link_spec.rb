require "spec_helper"

module Chartroom
  describe Link do
    let(:link_name)  { "rails" }
    let(:link_alias) { "web" }
    let(:param)      { "/#{link_name}:/nginx/#{link_alias}" }
    let(:link)       { described_class.new(param) }

    describe "#link_name" do
      it "should return link name" do
        expect(link.link_name).to eq link_name
      end
    end

    describe "#link_alias" do
      it "should return link alias" do
        expect(link.link_alias).to eq link_alias
      end
    end

    describe "#prettify" do
      it "should prettify" do
        expect(link.prettify).to eq "#{link_name}:#{link_alias}"
      end
    end
  end
end
