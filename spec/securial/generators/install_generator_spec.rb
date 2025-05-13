require "rails_helper"
require "generators/securial/install/install_generator"

RSpec.describe Securial::Generators::InstallGenerator, type: :generator do
  let(:destination_root) { Pathname.new(File.expand_path("../../../../../tmp", __dir__)) }

  destination File.expand_path("../../../../../tmp", __FILE__)

  before do
    prepare_destination
    allow(Rails).to receive(:root).and_return(destination_root)
    allow(destination_root).to receive(:join) { |*args| Pathname.new(File.join(destination_root, *args)) }
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  describe "generator" do
    it "creates the initializer file" do
      run_generator

      assert_file "config/initializers/securial.rb" do |content|
        assert_match(/Securial.configure do \|config\|/, content)
        assert_match(/config.log_to_file = false/, content)
        assert_match(/config.log_to_stdout = false/, content)
        assert_match(/config.file_log_level = :info/, content)
        assert_match(/config.stdout_log_level = :info/, content)
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
