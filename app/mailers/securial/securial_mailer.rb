module Securial
  class SecurialMailer < ApplicationMailer
    default from: Securial.configuration.mailer_sender

    def reset_password(securial_user)
      @user = securial_user
      subject = reset_password_subject
      mail subject: subject, to: securial_user.email_address
    end

    private

    def reset_password_subject
      Securial.configuration.password_reset_email_subject
    end
  end
end
