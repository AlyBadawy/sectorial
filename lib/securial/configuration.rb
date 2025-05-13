module Securial
  class Configuration
    attr_accessor :log_to_file, :log_to_stdout
    attr_accessor :file_log_level, :stdout_log_level

    def initialize
      @log_to_file = false
      @log_to_stdout = false
      @file_log_level = :info
      @stdout_log_level = :info
    end
  end
end
