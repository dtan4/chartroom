require "spec_helper"

module Chartroom
  describe Port do
    let(:private_port) { 80 }
    let(:public_port)  { 81 }
    let(:type)         { "tcp" }

    let(:params) do
      { "IP" => "0.0.0.0", "PrivatePort" => private_port, "PublicPort" => public_port, "Type" => type }
    end

    let(:port) { described_class.new(params) }

    describe "#private_port" do
      it "should return private_port" do
        expect(port.private_port).to eq private_port
      end
    end

    describe "#public_port" do
      it "should return public_port" do
        expect(port.public_port).to eq public_port
      end
    end

    describe "#type" do
      it "should return type" do
        expect(port.type).to eq type
      end
    end

    describe "prettify" do
      it "should prettify" do
        expect(port.prettify).to eq "#{private_port} -> #{public_port} (#{type.upcase})"
      end
    end

    describe "edge_description" do
      let(:id) { "abcd1234efgh" }

      it "should return edge description" do
        expect(port.edge_description(id)).to eq "container_#{id} -> port_#{public_port} [label=\"#{private_port} -> #{public_port}\"];"
      end
    end

    describe "node_description" do
      it "should return node description" do
        expect(port.node_description).to eq "port_#{public_port}[color=lawngreen, label=\"#{public_port}\", shape=ellipse];"
      end
    end
  end
end
