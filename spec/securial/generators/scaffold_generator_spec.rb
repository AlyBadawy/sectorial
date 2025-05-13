require "rails_helper"
require "generators/securial/scaffold/scaffold_generator"

RSpec.describe Securial::Generators::ScaffoldGenerator do
  subject(:generator) { described_class.new([name, *attributes]) }

  let(:name) { "post" }
  let(:attributes) { ["title:string", "body:text"] }

  before do
    allow(Securial::Engine).to receive(:root).and_return(Rails.root + "tmp/")

    # Clean up any previously generated files
    FileUtils.rm_rf(Rails.root.join("tmp/app/controllers/securial"))
    FileUtils.rm_rf(Rails.root.join("tmp/spec/requests/securial"))
    FileUtils.rm_rf(Rails.root.join("tmp/spec/routing/securial"))
  end

  describe ".file_name" do
    it "returns the correct manifest filename" do
      expect(described_class.file_name).to eq("generator_manifest.txt")
    end
  end

  describe "#run_scaffold" do
    context "when generating scaffold" do
      before do
        allow(Rails::Generators).to receive(:invoke)
        generator.run_scaffold
      end

      it "invokes both model and jbuilder generators" do
        expect(Rails::Generators).to have_received(:invoke).with(
          "model",
          [name, *attributes.map(&:to_s)],
          {
            behavior: :invoke,
            destination_root: (Rails.root + "tmp/"),
          }
        ).ordered

        expect(Rails::Generators).to have_received(:invoke).with(
          "securial:jbuilder",
          [name, *attributes],
          hash_including(
            behavior: :invoke,
            destination_root: Rails.root + "tmp/",
          )
        ).ordered
      end

      it "creates controller file in correct location" do
        generator.run_scaffold
        controller_path = Rails.root.join("tmp/app/controllers/securial/posts_controller.rb")
        expect(File).to exist(controller_path)
      end

      it "creates request spec file in correct location" do
        generator.run_scaffold
        request_spec_path = Rails.root.join("tmp/spec/requests/securial/posts_spec.rb")
        expect(File).to exist(request_spec_path)
      end

      it "creates routing spec file in correct location" do
        generator.run_scaffold
        routing_spec_path = Rails.root.join("tmp/spec/routing/securial/posts_routing_spec.rb")
        expect(File).to exist(routing_spec_path)
      end
    end

    context "when removing scaffold" do
      subject(:generator) do
        gen = described_class.new(generator_args)
        gen.behavior = :revoke
        gen
      end

      let(:generator_args) { [name, *attributes] }

      before do
        # First generate the files
        gen = described_class.new(generator_args)
        gen.behavior = :invoke
        gen.run_scaffold
      end

      it "removes all generated files" do
        # Remove the debugger line
        generator.run_scaffold

        expect(File).not_to exist(Rails.root.join("tmp/app/controllers/securial/posts_controller.rb"))
        expect(File).not_to exist(Rails.root.join("tmp/spec/requests/securial/posts_spec.rb"))
        expect(File).not_to exist(Rails.root.join("tmp/spec/routing/securial/posts_routing_spec.rb"))
      end
    end
  end

  describe "#status_behavior" do
    context "when behavior is :invoke" do
      subject(:generator) do
        gen = described_class.new(generator_args)
        gen.behavior = :invoke
        gen
      end

      let(:generator_args) { [name, *attributes] }

      it "returns :create" do
        expect(generator.send(:status_behavior)).to eq(:create)
      end
    end

    context "when behavior is :revoke" do
      subject(:generator) do
        gen = described_class.new(generator_args)
        gen.behavior = :revoke
        gen
      end

      let(:generator_args) { [name, *attributes] }

      it "returns :remove" do
        expect(generator.send(:status_behavior)).to eq(:remove)
      end
    end
  end

  describe "#status_color" do
    context "when behavior is :invoke" do
      subject(:generator) do
        gen = described_class.new(generator_args)
        gen.behavior = :invoke
        gen
      end

      let(:generator_args) { [name, *attributes] }

      it "returns :create" do
        expect(generator.send(:status_color)).to eq(:green)
      end
    end

    context "when behavior is :revoke" do
      subject(:generator) do
        gen = described_class.new(generator_args)
        gen.behavior = :revoke
        gen
      end

      let(:generator_args) { [name, *attributes] }

      it "returns :remove" do
        expect(generator.send(:status_color)).to eq(:red)
      end
    end
  end
end
