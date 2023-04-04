require 'rails_helper'

RSpec.describe "services/edit", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
      train: "MyString",
      horaire: "MyString",
      destination: "MyString"
    ))
  end

  it "renders the edit service form" do
    render

    assert_select "form[action=?][method=?]", service_path(@service), "post" do

      assert_select "input[name=?]", "service[train]"

      assert_select "input[name=?]", "service[horaire]"

      assert_select "input[name=?]", "service[destination]"
    end
  end
end
