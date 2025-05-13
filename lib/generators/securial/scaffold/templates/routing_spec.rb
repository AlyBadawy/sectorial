require "rails_helper"

RSpec.describe Securial::<%= controller_class_name %>Controller, type: :routing do
  routes { Securial::Engine.routes }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/<%= plural_table_name %>").to route_to("securial/<%= plural_table_name %>#index")
    end

    it "routes to #show" do
      expect(get: "/<%= plural_table_name %>/1").to route_to("securial/<%= plural_table_name %>#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/<%= plural_table_name %>").to route_to("securial/<%= plural_table_name %>#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/<%= plural_table_name %>/1").to route_to("securial/<%= plural_table_name %>#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/<%= plural_table_name %>/1").to route_to("securial/<%= plural_table_name %>#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/<%= plural_table_name %>/1").to route_to("securial/<%= plural_table_name %>#destroy", id: "1")
    end
  end
end