module Securial
  require "rails_helper"

  RSpec.describe Identity, type: :request do
    before do
      class TestController < ApplicationController # rubocop:disable RSpec/LeakyConstantDeclaration
        include Identity

        def index
          render json: { message: "Success" }
        end
      end

      Rails.application.routes.draw do
        mount Securial::Engine => "/securial"
      end

      Engine.routes.draw do
        get "/test", to: "test#index"
      end
    end

    after do
      Securial.send(:remove_const, :TestController) # rubocop:disable RSpec/RemoveConst
      Engine.routes.clear!
      Rails.application.reload_routes!
    end

    let(:securial_user) { create(:securial_user) }
    let(:securial_session) { create(:securial_session, user: securial_user) }
    let(:valid_headers) {
      token = JwtHelper.encode(securial_session)
      { "Authorization" => "Bearer #{token}" }
    }

    describe "GET /test" do
      context "with a valid token" do
        it "returns a successful response" do
          get "/securial/test", headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to include("message" => "Success")
        end
      end

      context "with an invalid token" do
        it "returns an unauthorized response" do
          get "/securial/test", headers: { "Authorization" => "Bearer invalid.token" }, as: :json
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns JSON error message of Invalid encoding" do
          get "/securial/test", headers: { "Authorization" => "Bearer invalid token" }, as: :json

          expect(JSON.parse(response.body)).to include("error" => "Invalid token: Invalid segment encoding")
        end
      end

      context "with a missing token" do
        it "returns an unauthorized response" do
          get "/securial/test", as: :json
          expect(response).to have_http_status(:unauthorized)
        end

        it "returns JSON error message of Missing or invalid Authorization header" do
          get "/securial/test", as: :json
          expect(JSON.parse(response.body)).to include("error" => "Missing or invalid Authorization header")
        end
      end
    end
  end
end
