module Securial
  class SecurialMailer < ApplicationMailer
    default from: ENV.fetch("EMAIL_FROM_ADDRESS") { "no-reply@example.com" }

    def reset_password(securial_user)
      @user = securial_user
      mail subject: "Reset your password", to: securial_user.email_address
    end
  end
end
