require "rails_helper"
require "generators/securial/scaffold/scaffold_generator"

RSpec.describe Securial::Generators::ScaffoldGenerator, type: :generator do
  destination File.expand_path("../../../../../tmp", __FILE__)

  let(:rails_generators) { class_spy(Rails::Generators) }

  before do
    prepare_destination
    stub_const("Rails::Generators", rails_generators)
  end

  after { FileUtils.rm_rf(destination_root) }

  describe "#run_scaffold" do
    context "with name and attributes" do
      let(:generator) { described_class.new(["Post", "title:string", "body:text"]) }

      it "invokes the Rails scaffold generator with correct parameters" do
        generator.run_scaffold

        expect(rails_generators).to have_received(:invoke).with(
          "scaffold",
          ["Post", "title:string", "body:text", "--api=false", "--template-engine=jbuilder"],
          hash_including(
            behavior: :invoke,
            destination_root: Rails.root,
          )
        )
      end
    end

    context "with name only" do
      let(:generator) { described_class.new(["User"]) }

      it "invokes the Rails scaffold generator with just the name" do
        generator.run_scaffold

        expect(rails_generators).to have_received(:invoke).with(
          "scaffold",
          ["User", "--api=false", "--template-engine=jbuilder"],
          hash_including(
            behavior: :invoke,
            destination_root: Rails.root,
          )
        )
      end
    end
  end
end
