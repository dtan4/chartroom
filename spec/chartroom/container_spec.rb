require "spec_helper"

module Chartroom
  describe Container do
    let(:container) { described_class.new(double(info: info, json: json)) }
    let(:info)      { {} }
    let(:json)      { {} }

    describe "#id" do
      let(:info) { { "id" => id } }
      let(:id)   { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }

      it "should return id parameter" do
        expect(container.id).to eq id
      end
    end

    describe "#short_id" do
      let(:info) { { "id" => id } }
      let(:id)   { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }

      it "should return id parameter" do
        expect(container.short_id).to eq id[0..11]
      end
    end

    describe "#name" do
      let(:json) { { "Name" => name } }
      let(:name) { "/name" }

      it "should return name parameter" do
        expect(container.name).to eq "name"
      end
    end

    describe "#image" do
      let(:info)  { { "Image" => image } }
      let(:image) { "hoge:latest" }

      it "should return image parameter" do
        expect(container.image).to eq image
      end
    end

    describe "#command" do
      let(:info)    { { "Command" => command } }
      let(:command) { "./docker-entrypoint.sh" }

      it "should return command parameter" do
        expect(container.command).to eq command
      end
    end

    describe "#links" do
      let(:json) { { "HostConfig" => { "Links" => links } } }

      context "when container is linked to another container" do
        let(:links) { ["/hoge:/fuga/hoge"] }

        it "should return links" do
          expect(container.links).to be_a Array
          expect(container.links[0]).to be_a Chartroom::Link
        end
      end

      context "when container is not linked" do
        let(:links) { nil }

        it "should return empty Array" do
          expect(container.links).to be_empty
        end
      end
    end

    describe "#formatted_links" do
      let(:json) { { "HostConfig" => { "Links" => links } } }

      context "when container is linked to another container" do
        let(:links) { ["/hoge:/fuga/hoge"] }

        it "should return stringified links" do
          expect(container.formatted_links).to eq "hoge:hoge"
        end
      end

      context "when container is not linked" do
        let(:links) { nil }

        it "should return empty Array" do
          expect(container.formatted_links).to eq ""
        end
      end
    end
  end
end
