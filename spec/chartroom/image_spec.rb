require "spec_helper"

module Chartroom
  describe Image do
    describe "#generate_diagram" do
      let(:image_1) { double(diagram_description: "image_1a[color=white, label=\"1a\", shape=ellipse];") }
      let(:image_2) { double(diagram_description: "image_2b[color=green, label=\"dtan4/hoge:latest\", shape=box];") }
      let(:image_3) { double(diagram_description: "image_3c[color=green, label=\"dtan4/fuga:latest\", shape=box];\nimage_3c -> image_2b;") }
      let(:images)  { [image_1, image_2, image_3] }

      it "should generate tree diagram in dot language" do
        expect(described_class.generate_diagram(images)).to eq <<-EXPECT
strict digraph images {
rankdir=BT;
node[style=filled];

image_1a[color=white, label="1a", shape=ellipse];
image_2b[color=green, label="dtan4/hoge:latest", shape=box];
image_3c[color=green, label="dtan4/fuga:latest", shape=box];
image_3c -> image_2b;
}
        EXPECT
      end
    end

    describe "#diagram_description" do
      let(:image) { described_class.new(double(info: info)) }

      context "when container is tagged" do
        let(:info) do
          {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["dtan4/fuga:latest"]}
        end

        it "should return diagram description" do
          expect(image.diagram_description).to eq <<-EXPECT
image_3c[color=green, label="dtan4/fuga:latest", shape=box];
image_3c -> image_2b;
        EXPECT
        end
      end

      context "when container is untagged" do
        let(:info) do
          {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["<none>:<none>"]}
        end

        it "should return diagram description" do
          expect(image.diagram_description).to eq <<-EXPECT
image_3c[color=white, label="3c", shape=ellipse];
image_3c -> image_2b;
        EXPECT
        end
      end

      context "when container has no parent" do
        let(:info) do
          {"id" => "3c", "ParentId" => "", "RepoTags" => ["<none>:<none>"]}
        end

        it "should return diagram description" do
          expect(image.diagram_description).to eq <<-EXPECT
image_3c[color=white, label="3c", shape=ellipse];

        EXPECT
        end
      end
    end
  end
end
