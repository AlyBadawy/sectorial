require "rails_helper"
require "ostruct"

RSpec.describe Securial::Logger do
  let(:log_path) { Rails.root.join("log", "securial_test.log") }
  let(:rails_root) { Pathname.new(File.expand_path("../dummy", __dir__)) }

  before do
    # Stub the Securial configuration for controlled tests
    allow(Securial).to receive(:configuration).and_return(OpenStruct.new(
      log_to_file: false,
      log_to_stdout: false,
      file_log_level: :info,
      stdout_log_level: :debug,
    ))
    FileUtils.rm_f(log_path)
  end

  describe ".build" do
    context "when logging to nothing" do
      it "returns a TaggedLogging wrapping a null logger" do
        logger = described_class.build
        expect(logger).to be_a(::Logger)
        expect(logger.instance_variable_get(:@logdev)).to be_nil
      end
    end

    context "when logging to file only" do
      before do
        allow(Securial.configuration).to receive(:log_to_file).and_return(true)
        allow(Rails).to receive(:root).and_return(rails_root)
        allow(rails_root).to receive(:join).with("log", "securial.log").and_return(log_path)
      end

      it "writes log to file" do
        logger = described_class.build
        logger.tagged("FILE") { logger.info("Test log to file") }

        expect(File.read(log_path)).to include("Test log to file")
      end
    end

    context "when logging to stdout only" do
      before do
        allow(Securial.configuration).to receive(:log_to_stdout).and_return(true)
      end

      it "writes to STDOUT" do
        logger = described_class.build

        expect {
          logger.info("Test log to stdout")
        }.to output(/I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+ #\d+\]  INFO -- : Test log to stdout\n/).to_stdout_from_any_process
      end
    end

    context "when logging to both file and stdout" do
      before do
        allow(Securial.configuration).to receive_messages(log_to_file: true, log_to_stdout: true)
        allow(Rails).to receive(:root).and_return(rails_root)
        allow(rails_root).to receive(:join).with("log", "securial.log").and_return(log_path)
      end

      it "writes to both destinations" do
        expect {
          logger = described_class.build
          logger.info("Test log to both")
        }.to output(/I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+ #\d+\]  INFO -- : Test log to both\n/).to_stdout_from_any_process

        expect(File.read(log_path)).to include("Test log to both")
      end
    end

    describe ".resolve_log_level" do
      it "returns the lower of the two log levels" do
        allow(Securial.configuration).to receive_messages(file_log_level: :warn, stdout_log_level: :debug)

        level = described_class.resolve_log_level
        expect(level).to eq(::Logger::DEBUG)
      end
    end
  end

  describe ".resolve_log_level" do
    before do
      allow(Securial).to receive(:configuration).and_return(OpenStruct.new(
        file_log_level: nil,
        stdout_log_level: nil,
      ))
    end

    it "returns INFO level when no levels are configured" do
      expect(described_class.resolve_log_level).to eq(::Logger::INFO)
    end

    it "returns the file level when only file level is set" do
      allow(Securial.configuration).to receive(:file_log_level).and_return(:debug)
      expect(described_class.resolve_log_level).to eq(::Logger::DEBUG)
    end

    it "returns the stdout level when only stdout level is set" do
      allow(Securial.configuration).to receive(:stdout_log_level).and_return(:error)
      expect(described_class.resolve_log_level).to eq(::Logger::ERROR)
    end

    it "returns the more verbose level when both levels are set" do
      allow(Securial.configuration).to receive_messages(
        file_log_level: :warn,
        stdout_log_level: :debug,
      )

      expect(described_class.resolve_log_level).to eq(::Logger::DEBUG)
    end

    it "handles invalid log levels by returning INFO" do
      allow(Securial.configuration).to receive_messages(
        file_log_level: :invalid,
        stdout_log_level: nil,
      )
      expect(described_class.resolve_log_level).to eq(::Logger::INFO)
    end

    it "compares all standard log levels correctly" do
      log_levels = %i[debug info warn error fatal]
      log_level_constants = log_levels.map { |level| ::Logger.const_get(level.to_s.upcase) }

      expect(log_level_constants).to eq(log_level_constants.sort)
    end
  end

  describe "MultiIO" do
    let(:target_one) { instance_spy(IO) }
    let(:target_two) { instance_spy(IO) }
    let(:multi_io) { described_class::MultiIO.new(target_one, target_two) }

    describe "#close" do
      it "does not close STDOUT or STDERR but closes other targets" do
        stdout = instance_spy(IO, write: nil, tty?: true)
        stderr = instance_spy(IO, write: nil, tty?: true)
        targets = [target_one, target_two, stdout, stderr]
        target_io = described_class::MultiIO.new(*targets)

        stub_const("STDOUT", stdout)
        stub_const("STDERR", stderr)
        target_io.close

        expect(target_one).to have_received(:close)
        expect(target_two).to have_received(:close)
        expect(stdout).not_to have_received(:close)
        expect(stderr).not_to have_received(:close)
      end
    end

    describe "#flush" do
      context "when targets respond to flush" do
        before do
          allow(target_one).to receive(:respond_to?).with(:flush).and_return(true)
          allow(target_two).to receive(:respond_to?).with(:flush).and_return(true)
        end

        it "flushes all targets" do
          multi_io.flush

          expect(target_one).to have_received(:flush)
          expect(target_two).to have_received(:flush)
        end
      end

      context "when targets don't respond to flush" do
        before do
          allow(target_one).to receive(:respond_to?).with(:flush).and_return(false)
          allow(target_two).to receive(:respond_to?).with(:flush).and_return(false)
        end

        it "skips flushing those targets" do
          multi_io.flush

          expect(target_one).not_to have_received(:flush)
          expect(target_two).not_to have_received(:flush)
        end
      end

      context "when some targets respond to flush" do
        before do
          allow(target_one).to receive(:respond_to?).with(:flush).and_return(true)
          allow(target_two).to receive(:respond_to?).with(:flush).and_return(false)
        end

        it "flushes only responding targets" do
          multi_io.flush

          expect(target_one).to have_received(:flush)
          expect(target_two).not_to have_received(:flush)
        end
      end
    end
  end
end
