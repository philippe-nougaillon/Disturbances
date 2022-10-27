require "rails_helper"

RSpec.describe SourcesUsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sources_users").to route_to("sources_users#index")
    end

    it "routes to #new" do
      expect(get: "/sources_users/new").to route_to("sources_users#new")
    end

    it "routes to #show" do
      expect(get: "/sources_users/1").to route_to("sources_users#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/sources_users/1/edit").to route_to("sources_users#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/sources_users").to route_to("sources_users#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/sources_users/1").to route_to("sources_users#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sources_users/1").to route_to("sources_users#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sources_users/1").to route_to("sources_users#destroy", id: "1")
    end
  end
end
