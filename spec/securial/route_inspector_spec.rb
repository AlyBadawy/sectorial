# frozen_string_literal: true

require 'rails_helper'

module Securial
  RSpec.describe RouteInspector do
    before do
      class TestController < ApplicationController # rubocop:disable RSpec/LeakyConstantDeclaration
        def not_found; raise ActiveRecord::RecordNotFound; end
        def bad_request; raise ActionController::ParameterMissing, "param"; end
        def invalid_encoding; raise JWT::DecodeError; end
        def expired_signature; raise JWT::ExpiredSignature; end
      end

      Rails.application.routes.draw do
        mount Securial::Engine => "/securial"
      end

      Securial::Engine.routes.draw do
        get "/test/not_found", to: "test#not_found"
        get "/test/bad_request", to: "test#bad_request"
        get "/test/invalid_encoding", to: "test#invalid_encoding"
        get "/test/expired_signature", to: "test#expired_signature"
      end
    end

    after do
      Securial.send(:remove_const, :TestController) # rubocop:disable RSpec/RemoveConst
      Securial::Engine.routes.clear!
      Rails.application.reload_routes!
    end

    def capture_stdout
      original_stdout = $stdout
      fake_stdout = StringIO.new
      $stdout = fake_stdout
      yield
      fake_stdout.string
    ensure
      $stdout = original_stdout
    end

    describe ".print_routes" do
      it "prints headers and route details" do
        output = capture_stdout { described_class.print_routes }

        expect(output).to include("Verb", "Path", "Controller#Action")
        expect(output).to include("test#not_found")
        expect(output).to include("test#bad_request")
        expect(output).to include("test#invalid_encoding")
        expect(output).to include("test#expired_signature")
      end

      it "prints only matching controller routes when filtered" do
        output = capture_stdout { described_class.print_routes(controller: "test") }

        expect(output).to include("Filtered by controller: test")
        expect(output).to include("test#not_found")
        expect(output).to include("test#bad_request")
        expect(output).to include("test#invalid_encoding")
        expect(output).to include("test#expired_signature")
      end

      it "prints appropriate message when no controller matches" do
        output = capture_stdout { described_class.print_routes(controller: "fake") }

        expect(output).to include("Filtered by controller: fake")
        expect(output).to include("No routes found for controller: fake")
      end

      it "prints appropriate message when no routes exist" do
        Securial::Engine.routes.clear!

        output = capture_stdout { described_class.print_routes }

        expect(output).to include("No routes found for Securial engine")
      end
    end
  end
end
