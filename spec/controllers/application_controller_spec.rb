require "rails_helper"

module Securial
  RSpec.describe ApplicationController, type: :request do
    before do
      class TestController < ApplicationController # rubocop:disable RSpec/LeakyConstantDeclaration
        def not_found
          raise ActiveRecord::RecordNotFound
        end

        def bad_request
          raise ActionController::ParameterMissing, "param"
        end

        def invalid_encoding
          raise JWT::DecodeError
        end

        def expired_signature
          raise JWT::ExpiredSignature
        end
      end

      Rails.application.routes.draw do
        mount Securial::Engine => "/securial"
      end

      Engine.routes.draw do
        get "/test/not_found", to: "test#not_found"
        get "/test/bad_request", to: "test#bad_request"
        get "/test/invalid_encoding", to: "test#invalid_encoding"
        get "/test/expired_signature", to: "test#expired_signature"
      end
    end

    after do
      Securial.send(:remove_const, :TestController) # rubocop:disable RSpec/RemoveConst
      Engine.routes.clear!
      Rails.application.reload_routes!
    end

    describe "Rescuing from ActiveRecord::RecordNotFound" do
      context "when visiting a route that raises ActiveRecord::RecordNotFound" do
        it "returns a 404 not found response" do
          get "/securial/test/not_found", as: :json
          expect(response).to have_http_status(:not_found)
        end

        it "returns a JSON error message of record not found" do
          get "/securial/test/not_found", as: :json
          expect(JSON.parse(response.body)).to include("error" => "Record not found")
        end
      end
    end

    describe "Rescuing from ActionController::ParameterMissing" do
      context "when visiting a route that raises ActionController::ParameterMissing" do
        it "returns a 400 bad request response" do
          get "/securial/test/bad_request", as: :json
          expect(response).to have_http_status(:bad_request)
        end

        it "returns a JSON error message of bad request" do
          get "/securial/test/bad_request", as: :json
          expect(JSON.parse(response.body)).to include(
            "error" => "param is missing or the value is empty or invalid: param",
          )
        end
      end
    end
  end
end
