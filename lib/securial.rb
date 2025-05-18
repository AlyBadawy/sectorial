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
      validate_admin_role!
    end

    # Returns the pluralized form of the admin role.
    # This behavior is intentional and aligns with the project's routing conventions.
    def admin_namespace
      configuration.admin_role.to_s.pluralize.downcase
    end

    private

    def validate_admin_role!
      error_message = "The admin role cannot be 'account' or 'accounts' as it conflicts with the default routes."

      if configuration.admin_role.to_s.pluralize.downcase == "accounts"
        Securial::ENGINE_LOGGER.error(error_message)
        raise RuntimeError, error_message
      end
    end
  end
end
