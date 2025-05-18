module Securial
  class Role < ApplicationRecord
    normalizes :role_name, with: ->(e) { e.strip.titleize }

    validates :role_name, presence: true, uniqueness: true

    has_many :role_assignments, dependent: :destroy
    has_many :users, through: :role_assignments
  end
end
