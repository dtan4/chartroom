require "spec_helper"

module Chartroom
  describe Image do
    describe "#generate_tree_diagram" do
      let(:image_1) { double(diagram_description: "1a[label=\"1a\"];") }
      let(:image_2) { double(diagram_description: "2b[label=\"dtan4/hoge:latest\"];") }
      let(:image_3) { double(diagram_description: "3c[label=\"dtan4/fuga:latest\"];\n3c -> 2b;") }
      let(:images)  { [image_1, image_2, image_3] }

      it "should generate tree diagram in dot language" do
        expect(described_class.generate_tree_diagram(images)).to eq <<-EXPECT
digraph images {
1a[label="1a"];
2b[label="dtan4/hoge:latest"];
3c[label="dtan4/fuga:latest"];
3c -> 2b;
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
3c[label="dtan4/fuga:latest"];
3c -> 2b;
        EXPECT
        end
      end

      context "when container is untagged" do
        let(:info) do
          {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["<none>:<none>"]}
        end

        it "should return diagram description" do
          expect(image.diagram_description).to eq <<-EXPECT
3c[label="3c"];
3c -> 2b;
        EXPECT
        end
      end

      context "when container has no parent" do
        let(:info) do
          {"id" => "3c", "ParentId" => "", "RepoTags" => ["<none>:<none>"]}
        end

        it "should return diagram description" do
          expect(image.diagram_description).to eq <<-EXPECT
3c[label="3c"];

        EXPECT
        end
      end
    end
  end
end
