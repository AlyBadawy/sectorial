module Securial
  class StatusController < ApplicationController
    def show
      Securial::ENGINE_LOGGER.info("Status check initiated")
    end
  end
end
