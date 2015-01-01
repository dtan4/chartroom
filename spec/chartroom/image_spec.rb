require "spec_helper"

module Chartroom
  describe Image do
    describe ".generate_diagram" do
      let(:image_1) do
        double(
          node_description: "image_1a[color=white, label=\"1a\", shape=ellipse];",
          tagged?: false, id: "1a", parent_id: ""
        )
      end

      let(:image_2) do
        double(
          node_description: "image_2b[color=green, label=\"dtan4/hoge:latest\", shape=box];",
          tagged?: true, id: "2b", parent_id: "1a"
        )
      end

      let(:image_3) do
        double(
          node_description: "image_3c[color=green, label=\"dtan4/fuga:latest\", shape=box];",
          tagged?: true, id: "3c", parent_id: "2b"
        )
      end

      let(:images)  { [image_1, image_2, image_3] }

      it "should generate tree diagram in dot language" do
        expect(described_class.generate_diagram(images)).to eq <<-EXPECT
strict digraph images {
rankdir=BT;
node[style=filled];

image_2b[color=green, label="dtan4/hoge:latest", shape=box];
image_1a[color=white, label="1a", shape=ellipse];
image_2b -> image_1a;
image_3c[color=green, label=\"dtan4/fuga:latest\", shape=box];
image_3c -> image_2b;
}
        EXPECT
      end
    end

    let(:image) { described_class.new(double(info: info)) }

    describe "#id" do
      let(:info) { { "id" => id } }
      let(:id)   { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }

      it "should return id parameter" do
        expect(image.id).to eq id
      end
    end

    describe "#short_id" do
      let(:info) { { "id" => id } }
      let(:id)   { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }

      it "should return shortened id" do
        expect(image.short_id).to eq id[0..11]
      end
    end

    describe "#repo_tags" do
      let(:info)      { { "RepoTags" => repo_tags } }
      let(:repo_tags) { ["hoge/fuga:latest"] }

      it "should return repo_tags parameter" do
        expect(image.repo_tags).to eq repo_tags
      end
    end

    describe "#virtual_size" do
      let(:info)         { { "VirtualSize" => virtual_size } }
      let(:virtual_size) { 12345 }

      it "should return virtual_size parameter" do
        expect(image.virtual_size).to eq virtual_size
      end
    end

    describe "#created_at" do
      let(:info)       { { "Created" => created_at } }
      let(:created_at) { 14193560445 }

      it "should return created_at parameter" do
        expect(image.created_at).to eq created_at
      end
    end

    describe "#parent_id" do
      let(:info)      { { "ParentId" => parent_id } }
      let(:parent_id) { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }

      it "should return parent_id parameter" do
        expect(image.parent_id).to eq parent_id
      end
    end

    describe "#short_parent_id" do
      let(:info)      { { "ParentId" => parent_id } }
      let(:parent_id) { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }

      it "should return shortened parent_id" do
        expect(image.short_parent_id).to eq parent_id[0..11]
      end
    end

    describe "#tagged?" do
      context "when image is tagged" do
        let(:info) { { "RepoTags" => ["hoge/fuga:latest"] } }

        it "should return true" do
          expect(image.tagged?).to be true
        end
      end

      context "when image is not tagged" do
        let(:info) { { "RepoTags" => ["<none>:<none>"] } }

        it "should return false" do
          expect(image.tagged?).to be false
        end
      end
    end

    describe "#node_description" do
      context "when image is tagged" do
        let(:info) do
          {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["dtan4/fuga:latest"]}
        end

        it "should return node description" do
          expect(image.node_description).to eq <<-EXPECT.strip
image_3c[color=lawngreen, label="dtan4/fuga:latest", shape=box];
        EXPECT
        end
      end

      context "when image is untagged" do
        let(:info) do
          {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["<none>:<none>"]}
        end

        it "should return node description" do
          expect(image.node_description).to eq <<-EXPECT.strip
image_3c[color=lightgray, label="3c", shape=ellipse];
        EXPECT
        end
      end
    end
  end
end
