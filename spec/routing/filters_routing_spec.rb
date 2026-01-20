require "rails_helper"

RSpec.describe FiltersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/filters").to route_to("filters#index")
    end

    it "routes to #new" do
      expect(get: "/filters/new").to route_to("filters#new")
    end

    it "routes to #show" do
      expect(get: "/filters/1").to route_to("filters#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/filters/1/edit").to route_to("filters#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/filters").to route_to("filters#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/filters/1").to route_to("filters#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/filters/1").to route_to("filters#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/filters/1").to route_to("filters#destroy", id: "1")
    end
  end
end
