require "rails_helper"

module Securial
  RSpec.describe SecurialMailer, type: :mailer do
    describe "#reset_password" do
      let (:user) { create(:securial_user) }
      let (:mail) { described_class.reset_password(user) }

      it "renders the headers" do
        expect(mail.subject).to eq("SECURIAL: Password Reset Instructions")
        expect(mail.to).to eq([user.email_address])
        expect(mail.from).to eq(["no-reply@example.com"])
      end

      it "renders the body" do
        expect(mail.body.encoded).to match("You can reset your password within the next 15 minutes on")
      end
    end
  end
end
