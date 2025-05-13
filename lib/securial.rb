require "securial/version"
require "securial/engine"
require "securial/configuration"

require "jbuilder"

module Securial
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    # Returns the pluralized form of the admin role.
    # This behavior is intentional and aligns with the project's routing conventions.
    def admin_namespace
      configuration.admin_role.to_s.pluralize
    end
  end
end
