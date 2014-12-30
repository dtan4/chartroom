require "spec_helper"

module Chartroom
  describe Container do
    let(:container) { described_class.new(double(info: info, json: json)) }
    let(:info)      { {} }
    let(:json)      { {} }

    describe ".genrate_diagram" do
      let(:container_1) do
        double(
          node_description: "container_1a[label=\"1a\", shape=box];",
          ports_description: ["80 -> 80 (TCP);"],
          id: "1a", name: "1a", links: []
        )
      end

      let(:container_2) do
        double(
          node_description: "container_2b[label=\"2b\", shape=box];",
          ports_description: [],
          id: "2b", name: "2b", links: [Chartroom::Link.new("/1a:/2b/1a")]
        )
      end

      let(:containers) { [container_1, container_2] }

      it "should return diagram in dot language" do
        expect(described_class.generate_diagram(containers)).to eq <<-EXPECT
strict digraph containers {
rankdir=BT;
node[style=filled];

container_1a[label=\"1a\", shape=box];
80 -> 80 (TCP);
container_2b[label=\"2b\", shape=box];
container_2b -> container_1a [label="1a:1a"];
}
        EXPECT
      end
    end

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

      it "should return shortened id" do
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
          result = container.links
          expect(result).to be_a Array
          expect(result[0]).to be_a Chartroom::Link
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

    describe "#ports" do
      let(:info) { { "Ports" => ports } }
      let(:ports) do
        [{ "IP" => "0.0.0.0", "PrivatePort" => 80, "PublicPort" => 80, "Type"  => "tcp" }, { "PrivatePort" => 443, "Type" => "tcp" }]
      end

      it "should return ports" do
        result = container.ports
        expect(result).to be_a Array
        expect(result.length).to eq 1
        expect(result[0]).to be_a Chartroom::Port
      end
    end

    describe "#formatted_ports" do
      let(:info)  { { "Ports" => ports } }
      let(:ports) do
        [{ "IP" => "0.0.0.0", "PrivatePort" => 80, "PublicPort" => 80, "Type"  => "tcp" }, { "PrivatePort" => 443, "Type" => "tcp" }]
      end

      it "should return stringified ports" do
        expect(container.formatted_ports).to eq "80 -> 80 (TCP)"
      end
    end

    describe "#status" do
      let(:info)   { { "Status" => status } }
      let(:status) { "Up 4 minutes" }

      it "should return status parameter" do
        expect(container.status).to eq status
      end
    end

    describe "#node_description" do
      let(:info) { { "id" => id } }
      let(:json) { { "Name" => name } }
      let(:id)   { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }
      let(:name) { "/name" }

      it "should return node description" do
        expect(container.node_description).to eq "container_12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216[label=\"name\", shape=box];"
      end
    end

    describe "ports_description" do
      let(:info) { { "id" => id, "Ports" => ports } }
      let(:id)   { "12a324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216" }
      let(:ports) do
        [{ "IP" => "0.0.0.0", "PrivatePort" => 80, "PublicPort" => 80, "Type"  => "tcp" }, { "PrivatePort" => 443, "Type" => "tcp" }]
      end

      it "should call port#edge_description" do
        expect_any_instance_of(Chartroom::Port).to receive(:edge_description).once
        container.ports_description
      end

      it "should call port#node_description" do
        expect_any_instance_of(Chartroom::Port).to receive(:node_description).once
        container.ports_description
      end
    end
  end
end
