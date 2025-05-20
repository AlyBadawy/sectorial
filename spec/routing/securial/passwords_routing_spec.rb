require 'rails_helper'

  RSpec.describe Securial::PasswordsController, type: :routing do
    let(:default_format) { :json }

    describe 'routing' do
      it 'routes to #forgot_password' do
        expect(post: "/securial/password/forgot").to route_to("securial/passwords#forgot_password", format: default_format)
      end

      it 'routes to #reset_password' do
        expect(put: "/securial/password/reset").to route_to("securial/passwords#reset_password", format: default_format)
      end
    end
  end
