require "rails_helper"

RSpec.describe Securial do
  describe "VERSION" do
    subject { described_class::VERSION }

    it "has a version number" do
      expect(subject).not_to be_nil
    end

    it "follows semantic versioning format" do
      expect(subject).to match(/^\d+\.\d+\.\d+$/)
    end

    it "is the correct version" do
      expect(subject).to eq("0.3.0")
    end

    it "has three version segments" do
      major, minor, patch = subject.split(".")
      expect(major).to match(/^\d+$/)
      expect(minor).to match(/^\d+$/)
      expect(patch).to match(/^\d+$/)
    end

    it "can be compared with other versions" do
      expect(Gem::Version.new(subject)).to be_a(Gem::Version)
    end

    it "is included in the gem specification" do
      expect(Gem.loaded_specs["securial"].version.to_s).to eq(subject)
    end
  end
end
