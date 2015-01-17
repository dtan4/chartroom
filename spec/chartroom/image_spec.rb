require "spec_helper"

module Chartroom
  describe Image do
    describe ".generate_diagram" do
      let(:image_1) do
        described_class.new(double(
          info: {
            "id" => "1aa324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            "ParentId" => "",
            "RepoTags" => [],
          }
        ))
      end

      let(:image_2) do
        described_class.new(double(
          info: {
            "id" => "2ba324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            "ParentId" => "1aa324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            "RepoTags" => ["dtan4/hoge:latest"],
          }
        ))
      end

      let(:image_3) do
        described_class.new(double(
          info: {
            "id" => "3ca324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            "ParentId" => "2ba324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            "RepoTags" => ["dtan4/fuga:latest"],
          }
        ))
      end

      let(:image_4) do
        described_class.new(double(
          info: {
            "id" => "4da324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            "ParentId" => "1aa324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            "RepoTags" => ["<none>:<none>"],
          }
        ))
      end

      let(:images)  { [image_1, image_2, image_3, image_4] }

      it "should generate tree diagram Hash" do
        expect(described_class.generate_diagram(images)).to eql([
          {
            id: "1aa324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
            tagged: false,
            name: "1aa324d4afc1",
            children: [
              {
                id: "2ba324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
                tagged: true,
                name: "dtan4/hoge:latest",
                children: [
                  {
                    id: "3ca324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
                    tagged: true,
                    name: "dtan4/fuga:latest",
                    children: [],
                  },
                ],
              },
            ],
          },
        ])
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
  end
end
