module Securial
  class PasswordsMailer < ApplicationMailer
    default from: ENV.fetch("EMAIL_FROM_ADDRESS") { "no-reply@example.com" }

    def reset(user)
      @user = user
      mail subject: "Reset your password", to: user.email_address
    end
  end
end
