# lib/generators/securial/jbuilder/jbuilder_generator_test.rb
require "spec_helper"
require "generators/securial/jbuilder/jbuilder_generator"

RSpec.describe Securial::Generators::JbuilderGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  before(:each) do
    prepare_destination
    allow(Rails.env).to receive(:test?).and_return(true)
  end

  let(:generator) { described_class.new(["user", "name:string", "email:string"]) }

  describe "generator configuration" do
    it "inherits from NamedBase" do
      expect(described_class.superclass).to eq Rails::Generators::NamedBase
    end

    it "has the correct source root" do
      expected_path = File.expand_path("templates", File.dirname(File.dirname(__FILE__)))
      expect(described_class.source_root.to_s).to end_with("templates")
    end
  end

  describe "#create_view_files" do
    before { generator.create_view_files }
    after { FileUtils.rm_rf(Rails.root.join("tmp")) }

    it "creates all view files" do
      expect(Rails.root.to_s + "/tmp").to have_structure {
        directory "app" do
          directory "views" do
            directory "securial" do
              directory "users" do
                file "_user.json.jbuilder"
                file "index.json.jbuilder"
                file "show.json.jbuilder"
              end
            end
          end
        end
      }
    end
  end

  describe "#attributes_names" do
    it "returns array of attribute names" do
      expect(generator.send(:attributes_names)).to eq(["name", "email"])
    end
  end

  describe "#status_behavior" do
    it "returns :create when behavior is :invoke" do
      allow(generator).to receive(:behavior).and_return(:invoke)
      expect(generator.send(:status_behavior)).to eq(:create)
    end

    it "returns :remove when behavior is :revoke" do
      allow(generator).to receive(:behavior).and_return(:revoke)
      expect(generator.send(:status_behavior)).to eq(:remove)
    end
  end

  describe "#status_color" do
    it "returns :green when behavior is :invoke" do
      allow(generator).to receive(:behavior).and_return(:invoke)
      expect(generator.send(:status_color)).to eq(:green)
    end

    it "returns :red when behavior is :revoke" do
      allow(generator).to receive(:behavior).and_return(:revoke)
      expect(generator.send(:status_color)).to eq(:red)
    end
  end
end
