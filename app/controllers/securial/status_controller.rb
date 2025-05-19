module Securial
  class StatusController < ApplicationController
    skip_authentication!

    def show
      Securial::ENGINE_LOGGER.info("Status check initiated")
    end
  end
end
