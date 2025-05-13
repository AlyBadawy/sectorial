module Securial
  class TestModelsController < ApplicationController
    before_action :set_securial_test_model, only: [:show, :update, :destroy]

    def index
      @securial_test_models = TestModel.all
    end

    def show
    end

    def create
      @securial_test_model = TestModel.new(securial_test_model_params)

      if @securial_test_model.save
        render :show, status: :created, location: @securial_test_model
      else
        render json: @securial_test_model.errors, status: :unprocessable_entity
      end
    end

    def update
      if @securial_test_model.update(securial_test_model_params)
        render :show
      else
        render json: @securial_test_model.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @securial_test_model.destroy
    end

    private

    def set_securial_test_model
      @securial_test_model = TestModel.find(params[:id])
    end

    def securial_test_model_params
      params.expect(securial_test_model: [:title, :body])
    end
  end
end
