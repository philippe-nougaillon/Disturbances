require 'rails_helper'

RSpec.describe "filters/new", type: :view do
  before(:each) do
    assign(:filter, Filter.new(
      user: nil,
      name: "MyString",
      trains: "MyString"
    ))
  end

  it "renders new filter form" do
    render

    assert_select "form[action=?][method=?]", filters_path, "post" do

      assert_select "input[name=?]", "filter[user_id]"

      assert_select "input[name=?]", "filter[name]"

      assert_select "input[name=?]", "filter[trains]"
    end
  end
end
