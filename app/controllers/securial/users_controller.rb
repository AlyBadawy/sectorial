module Securial
  class UsersController < ApplicationController
    before_action :set_securial_user, only: [:show, :update, :destroy]

    def index
      @securial_users = User.all
    end

    def show
    end

    def create
      @securial_user = User.new(securial_user_params)

      if @securial_user.save
        render :show, status: :created, location: @securial_user
      else
        render json: @securial_user.errors, status: :unprocessable_entity
      end
    end

    def update
      if @securial_user.update(securial_user_params)
        render :show, status: :ok, location: @user
      else
        render json: @securial_user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @securial_user.destroy!
    end

    private

    def set_securial_user
      @securial_user = User.find(params.expect(:id))
    end

    def securial_user_params
      params.expect(securial_user: [
                      :email_address,
                      :password,
                      :password_confirmation,
                      :first_name,
                      :last_name,
                      :phone,
                      :username,
                      :bio
                    ])
    end
  end
end
