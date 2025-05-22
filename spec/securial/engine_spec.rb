require 'rails_helper'

RSpec.describe Securial::Engine do
  describe 'controller extensions' do
    describe 'ActionController::Base integration' do
      let(:controller) { ActionController::Base.new }

      it 'includes Securial::Identity in ActionController::Base' do
        expect(ActionController::Base.included_modules).to include(Securial::Identity)
      end

      it 'makes Identity methods available to Base controllers' do
        expect(controller).to respond_to(:current_user)
        expect(controller).to respond_to(:authenticate_admin!)
      end
    end

    describe 'ActionController::API integration' do
      let(:controller) { ActionController::API.new }

      it 'includes Securial::Identity in ActionController::API' do
        expect(ActionController::API.included_modules).to include(Securial::Identity)
      end

      it 'makes Identity methods available to API controllers' do
        expect(controller).to respond_to(:current_user)
        expect(controller).to respond_to(:authenticate_admin!)
      end
    end

    describe 'helper methods' do
      let(:base_controller) { ActionController::Base.new }

      it 'registers current_user as a helper method in Base controllers' do
        expect(ActionController::Base._helper_methods).to include(:current_user)
      end

      it 'does not register helper methods in API controllers' do
        expect(ActionController::API._helper_methods).to be_empty
      end
    end
  end
end
