module Securial
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    before_create :generate_uuid_v7

    private

    def generate_uuid_v7
      return if self.id.present?
      return unless [:string, :uuid].include?(self.class.columns_hash["id"].type)

      self.id ||= Random.uuid_v7
    end
  end
end
