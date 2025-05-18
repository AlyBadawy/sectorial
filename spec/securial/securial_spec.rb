require "rails_helper"

RSpec.describe Securial do
  describe ".configure" do
    it "yields the configuration object" do
      expect { |b| described_class.configure(&b) }.to yield_with_args(instance_of(Securial::Configuration))
    end

    it "allows setting configuration values" do
      described_class.configure do |config|
        config.log_to_file = true
        config.log_to_stdout = false
        config.file_log_level = :debug
      end

      expect(described_class.configuration.log_to_file).to be true
      expect(described_class.configuration.log_to_stdout).to be false
      expect(described_class.configuration.file_log_level).to eq :debug
    end

    it "maintains configuration between calls" do
      described_class.configure do |config|
        config.log_to_file = true
      end

      described_class.configure do |config|
        config.log_to_stdout = true
      end

      expect(described_class.configuration.log_to_file).to be true
      expect(described_class.configuration.log_to_stdout).to be true
    end
  end

  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(Securial::Configuration)
    end

    it "memoizes the configuration" do
      config1 = described_class.configuration
      config2 = described_class.configuration

      expect(config1).to be(config2)
    end

    it "allows setting a custom configuration" do
      custom_config = Securial::Configuration.new
      described_class.configuration = custom_config

      expect(described_class.configuration).to be(custom_config)
    end

    it "creates a new configuration if none exists" do
      described_class.configuration = nil
      expect(described_class.configuration).to be_a(Securial::Configuration)
    end
  end

  describe ".validate_admin_role!" do
    let(:error_message) { "The admin role cannot be 'admin' or 'admins' as it conflicts with the default routes." }

    before do
      # Reset configuration before each test
      described_class.configuration = Securial::Configuration.new
    end

    context "when admin_role conflicts with accounts namespace" do
      it 'raises error when admin_role is "account"' do
        described_class.configuration.admin_role = "account"

        expect {
          described_class.send(:validate_admin_role!)
        }.to raise_error(RuntimeError, error_message)
      end

      it 'raises error when admin_role is "accounts"' do
        described_class.configuration.admin_role = "accounts"

        expect {
          described_class.send(:validate_admin_role!)
        }.to raise_error(RuntimeError, error_message)
      end
    end

    context "when admin_role is valid" do
      it "does not raise error for valid role names" do
        valid_roles = ["manager", "supervisor", "moderator"]

        valid_roles.each do |role|
          described_class.configuration.admin_role = role
          expect {
            described_class.send(:validate_admin_role!)
          }.not_to raise_error
        end
      end
    end
  end
end
