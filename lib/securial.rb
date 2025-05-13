require "securial/version"
require "securial/engine"
require "securial/configuration"

require "jbuilder"

module Securial
  class << self
    attr_writer :configuration

    def admin_namespace
      configuration.admin_role.to_s.pluralize
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
