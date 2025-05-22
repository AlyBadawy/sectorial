module Securial
  class User < ApplicationRecord
    has_secure_password

    VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
    # URI::MailTo::EMAIL_REGEXP - Regex for validating email addresses
    # /\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/

    # \A - Start of string
    #
    # [a-zA-Z0-9.!#$%&'*+\/=?^_{|}~-]+`: One or more characters that can be:
    #  Letters (a-z, A-Z)
    #  Numbers (0-9)
    #  Special characters: .!#$%&'*+/=?^_\{|}~-`
    #
    # @ - At sign: Literal @ character
    #
    # Domain Part (after @):
    # [a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?
    #   [a-zA-Z0-9]: Starts with a letter or number
    #   (?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?: Optional group that can contain:
    #       Up to 61 characters of alphanumeric or hyphens
    #       Must end with alphanumeric
    #
    # Multiple Subdomains:
    # (?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*
    #   Matches zero or more occurrences of:
    #   A dot followed by a domain part (same as above)
    #   Ensures the string ends with a valid domain part
    #   This regex allows for subdomains and top-level domains (TLDs)
    #
    #   \z - End of string

    # This regex is used to validate email addresses in the User model.
    # Examples of Valid Emails:
    #   - user@example.com
    #   - user.name+tag@example.co.uk
    #   - user123@subdomain.example.com

    VALID_USERNAME_REGEX = /\A(?![0-9])[a-zA-Z](?:[a-zA-Z0-9]|[._](?![._]))*[a-zA-Z0-9]\z/

    normalizes :email_address, with: ->(e) { e.strip.downcase }
    validates :email_address,
              presence: true,
              uniqueness: true,
              length: { minimum: 5, maximum: 255 },
              format: { with: VALID_EMAIL_REGEX, message: "must be a valid email address" }

    validates :username,
              presence: true,
              uniqueness: { case_sensitive: false },
              length: { maximum: 20 },
              format: {
                with: VALID_USERNAME_REGEX,
                message: "can only contain letters, numbers, underscores, and periods, but cannot start with a number or contain consecutive underscores or periods",
              }

    validates :first_name,
              presence: true,
              length: { maximum: 50 }
    validates :last_name,
              presence: true,
              length: { maximum: 50 }

    validates :phone,
              length: { maximum: 15 },
              allow_blank: true
    validates :bio,
              length: { maximum: 1000 },
              allow_blank: true

    has_many :role_assignments, dependent: :destroy
    has_many :roles, through: :role_assignments

    has_many :sessions, dependent: :destroy


    def is_admin?
      roles.exists?(role_name: Securial.configuration.admin_role.to_s.strip.titleize)
    end
  end
end
