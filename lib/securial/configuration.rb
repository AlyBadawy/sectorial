module Securial
  class Configuration
    attr_accessor :log_to_file, :log_to_stdout
    attr_accessor :log_file_level, :log_stdout_level
    attr_accessor :admin_role
    attr_accessor :session_expiration_duration
    attr_accessor :session_secret, :session_algorithm

    def initialize
      @log_to_file = !Rails.env.test?
      @log_to_stdout = !Rails.env.test?
      @log_file_level = :info
      @log_stdout_level = :info
      @admin_role = :admin
      @session_expiration_duration = 3.minutes
      @session_secret = "secret"
      @session_algorithm = :hs256
    end
  end
end
