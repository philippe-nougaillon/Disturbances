require 'rails_helper'

RSpec.describe "services/new", type: :view do
  before(:each) do
    assign(:service, Service.new(
      train: "MyString",
      horaire: "MyString",
      destination: "MyString"
    ))
  end

  it "renders new service form" do
    render

    assert_select "form[action=?][method=?]", services_path, "post" do

      assert_select "input[name=?]", "service[train]"

      assert_select "input[name=?]", "service[horaire]"

      assert_select "input[name=?]", "service[destination]"
    end
  end
end
