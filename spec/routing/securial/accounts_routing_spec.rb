require "rails_helper"

RSpec.describe Securial::AccountsController, type: :routing do
  let(:default_format) { :json }

  describe "routing" do
    it "routes to GET '/securial/accounts/me' for current user account" do
      expect(get: "/securial/accounts/me").to route_to("securial/accounts#me", format: default_format)
    end

    it "routes to GET '/securial/accounts/account/cool_user' to get user profile by username" do
      expect(get: "/securial/accounts/account/cool_user").to route_to("securial/accounts#show", username: "cool_user", format: default_format)
    end

    it "routes to POST '/securial/accounts/register' to register a new account" do
      expect(post: "/securial/accounts/register").to route_to("securial/accounts#register", format: default_format)
    end

    it "routes to PUT '/securial/accounts/update' to update current user's profile" do
      expect(put: "/securial/accounts/update").to route_to("securial/accounts#update_profile", format: default_format)
    end

    it "routes to DELETE '/securial/accounts/delete_account' to delete current user's account" do
      expect(delete: "/securial/accounts/delete_account").to route_to("securial/accounts#delete_account", format: default_format)
    end
  end
end
