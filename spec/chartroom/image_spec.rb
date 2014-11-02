require "spec_helper"

module Chartroom
  describe Image do
    describe "#generate_tree_diagram" do
      let(:image_1) { double(diagram_description: "1a[label=\"1a\"]") }
      let(:image_2) { double(diagram_description: "2b[label=\"dtan4/hoge\"]") }
      let(:image_3) { double(diagram_description: "3c[label=\"dtan4/fuga\"]\n3c -> 2b") }
      let(:images)  { [image_1, image_2, image_3] }

      it "should generate tree diagram in dot language" do
        expect(described_class.generate_tree_diagram(images)).to eq <<-EXPECT
digraph images {
1a[label="1a"]
2b[label="dtan4/hoge"]
3c[label="dtan4/fuga"]
3c -> 2b
}
        EXPECT
      end
    end

    describe "#diagram_description" do
      let(:info) do
        {"id" => "3c", "ParentId" => "2b", "RepoTags" => ["dtan4/fuga"]}
      end

      let(:image) { described_class.new(double(info: info)) }

      it "should return diagram description" do
        expect(image.diagram_description).to eq <<-EXPECT
3c[label="dtan4/fuga"]
3c -> 2b
        EXPECT
      end
    end
  end
end
