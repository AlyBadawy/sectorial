require 'rails_helper'

RSpec.describe Securial::PasswordsController, type: :request do
  describe "POST /forgot" do
    it "always returns 200 OK response regardless of whether a user exists." do
      post securial.forgot_password_url, params: { email_address: @signed_in_user.email_address }
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(
        {
          "message" => "Password reset instructions sent (if user with that email address exists).",
        }
      )
    end

    it "Send an email if the user exists" do
      allow(Securial::SecurialMailer).to receive(:reset_password).and_call_original
      post securial.forgot_password_url, params: { email_address: @signed_in_user.email_address }
      expect(Securial::SecurialMailer).to have_received(:reset_password).with(@signed_in_user).exactly(1)
    end

    it "Doesn't send an email if the user doesn't exist" do
      allow(Securial::SecurialMailer).to receive(:reset_password).and_call_original
      post securial.forgot_password_url, params: { email_address: "wrong@email.com" }
      expect(Securial::SecurialMailer).not_to have_received(:reset_password)
    end
  end

  describe "PUT /passwords" do
    context "when Correct token for a user is provided" do
      it "renders a successful response" do
        @signed_in_user.generate_reset_password_token!
        token = @signed_in_user.reset_password_token
        put securial.reset_password_url, params: {
                                  token: token,
                                  password: "New_password0",
                                  password_confirmation: "New_password0",
                                }
        expect(response).to be_successful
      end

      it "resets the password when password is valid" do
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "New_password0",
          )
        ).to be_nil
        @signed_in_user.generate_reset_password_token!
        token = @signed_in_user.reset_password_token
        put securial.reset_password_url, params: {
                                  token: token,
                                  password: "New_password0",
                                  password_confirmation: "New_password0",
                                }
        expect(JSON.parse(response.body)).to eq(
          { "message" => "Password has been reset." }
        )
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "New_password0",
          )
        ).to eq(@signed_in_user)
      end

      it "doesn't reset the password when password is invalid" do
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "New_password0",
          )
        ).to be_nil
        @signed_in_user.generate_reset_password_token!
        token = @signed_in_user.reset_password_token
        put securial.reset_password_url, params: {
                                  token: token,
                                  password: "New_password0",
                                  password_confirmation: "incorrect",
                                }
        expect(JSON.parse(response.body)).to eq(
          { "errors" => { "password_confirmation" => ["doesn't match Password"] } }
        )
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "New_password0",
          )
        ).to be_nil
      end
    end

    context "when Incorrect token for a user is provided" do
      it "renders a unprocessable_entity response" do
        put securial.reset_password_url,
            params: {
              token: "invalid_token",
              password: "New_password0",
              password_confirmation: "New_password0",
            }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          { "errors" => { "token" => "is invalid or has expired" } }
        )
      end

      it "Doesn't reset the password" do
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "Password_.1",
          )
        ).to eq(@signed_in_user)
        put securial.reset_password_url,
            params: {
              token: "invalid_token",
              password: "New_password0",
              password_confirmation: "New_password0",
            }
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "New_password0",
          )
        ).to be_nil

        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "Password_.1",
          )
        ).to eq(@signed_in_user)
      end
    end

    context "when token is expired" do
      it "renders a unprocessable_entity response" do
        @signed_in_user.generate_reset_password_token!
        @signed_in_user.update!(reset_password_token_created_at: 3.hours.ago)
        token = @signed_in_user.reset_password_token
        put securial.reset_password_url, params: {
                                  token: token,
                                  password: "New_password0",
                                  password_confirmation: "New_password0",
                                }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          { "errors" => { "token" => "is invalid or has expired" } }
        )
      end

      it "Doesn't reset the password" do
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "Password_.1",
          )
        ).to eq(@signed_in_user)
        @signed_in_user.generate_reset_password_token!
        @signed_in_user.update!(reset_password_token_created_at: 3.hours.ago)
        put securial.reset_password_url, params: {
                                  token: @signed_in_user.reset_password_token,
                                  password: "New_password0",
                                  password_confirmation: "New_password0",
                                }
        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "New_password0",
          )
        ).to be_nil

        expect(
          Securial::User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "Password_.1",
          )
        ).to eq(@signed_in_user)
      end
    end
  end
end
