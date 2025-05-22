module Securial
  # Preview all emails at http://localhost:3000/rails/mailers/securial/passwords_mailer
  class SecurialMailerPreview < ActionMailer::Preview
    def reset_password
      user = FactoryBot.create(:securial_user)
      SecurialMailer.reset_password(user)
    end
  end
end
