require "rails_helper"
require "generators/securial/install/install_generator"

RSpec.describe Securial::Generators::InstallGenerator, type: :generator do
  let(:destination_root) { Pathname.new(File.expand_path(Securial::Engine.root.join("tmp"), __dir__)) }

  destination File.expand_path(Securial::Engine.root.join("tmp"), __FILE__)

  before do
    prepare_destination
    allow(Rails).to receive(:root).and_return(destination_root)
    allow(destination_root).to receive(:join) { |*args| Pathname.new(File.join(destination_root, *args)) }
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  describe "generator" do
    describe "securial.factories" do
      let(:app) { Rails.application }
      let(:engine) { Securial::Engine.instance }

      context "when FactoryBot is defined" do
        before do
          stub_const("FactoryBot", Module.new do
            def self.definition_file_paths
              @paths ||= []
            end

            def self.definition_file_paths=(paths)
              @paths = paths
            end
          end)
          allow(engine).to receive(:root).and_return(Pathname.new("/dummy/path"))
        end

        it "adds engine factories path to FactoryBot definition paths" do
          FactoryBot.definition_file_paths = []

          # Trigger the initializer
          engine.initializers.find { |i| i.name == "securial.factories" }.run(app)

          expected_path = engine.root.join("lib", "securial", "factories")
          expect(FactoryBot.definition_file_paths).to include(expected_path)
        end
      end

      context "when FactoryBot is not defined" do
        before do
          hide_const("FactoryBot") if defined?(FactoryBot)
        end

        it "does not raise error" do
          expect {
            engine.initializers.find { |i| i.name == "securial.factories" }.run(app)
          }.not_to raise_error
        end
      end
    end

    it "creates the initializer file" do
      run_generator

      assert_file Rails.root.join("config/initializers/securial.rb") do |content|
        assert_match(/Securial.configure do \|config\|/, content)
        assert_match(/config.log_to_file = true/, content)
        assert_match(/config.log_to_stdout = true/, content)
        assert_match(/config.log_file_level = :info/, content)
        assert_match(/config.log_stdout_level = :info/, content)
      end
    end

    it "creates the log directory if it doesn't exist" do
      run_generator
      expect(File.directory?(File.join(destination_root, "log"))).to be true
    end

    it "creates the log file" do
      run_generator
      expect(File.exist?(File.join(destination_root, "log", "securial.log"))).to be true
    end

    context "when log directory already exists" do
      before do
        FileUtils.mkdir_p(File.join(destination_root, "log"))
      end

      it "doesn't raise error" do
        expect { run_generator }.not_to raise_error
      end

      it "creates the log file" do
        run_generator
        expect(File.exist?(File.join(destination_root, "log", "securial.log"))).to be true
      end
    end

    context "when log file already exists" do
      before do
        FileUtils.mkdir_p(File.join(destination_root, "log"))
        FileUtils.touch(File.join(destination_root, "log", "securial.log"))
      end

      it "doesn't raise error" do
        expect { run_generator }.not_to raise_error
      end
    end
  end
end
