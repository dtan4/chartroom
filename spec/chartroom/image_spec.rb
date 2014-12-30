require "spec_helper"

module Chartroom
  describe Image do
    describe ".generate_diagram" do
      let(:image_1) do
        double(
          node_description: "image_1a[color=white, label=\"1a\", shape=ellipse];",
          tagged?: false, id: "1a", parent_id: "")
      end

      let(:image_2) do
        double(
          node_description: "image_2b[color=green, label=\"dtan4/hoge:latest\", shape=box];",
          tagged?: true, id: "2b", parent_id: "1a")
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
image_3c[color=green, label="dtan4/fuga:latest", shape=box];
image_3c -> image_2b;
}
        EXPECT
      end
    end

    describe "#node_description" do
      let(:image) { described_class.new(double(info: info)) }

      context "when container is tagged" do
        let(:info) do
          {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["dtan4/fuga:latest"]}
        end

        it "should return diagram description" do
          expect(image.node_description).to eq <<-EXPECT.strip
image_3c[color=lawngreen, label="dtan4/fuga:latest", shape=box];
        EXPECT
        end
      end

      context "when container is untagged" do
        let(:info) do
          {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["<none>:<none>"]}
        end

        it "should return diagram description" do
          expect(image.node_description).to eq <<-EXPECT.strip
image_3c[color=lightgray, label="3c", shape=ellipse];
        EXPECT
        end
      end
    end
  end
end
