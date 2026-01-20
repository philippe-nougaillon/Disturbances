require 'rails_helper'

RSpec.describe "filters/edit", type: :view do
  before(:each) do
    @filter = assign(:filter, Filter.create!(
      user: nil,
      name: "MyString",
      trains: "MyString"
    ))
  end

  it "renders the edit filter form" do
    render

    assert_select "form[action=?][method=?]", filter_path(@filter), "post" do

      assert_select "input[name=?]", "filter[user_id]"

      assert_select "input[name=?]", "filter[name]"

      assert_select "input[name=?]", "filter[trains]"
    end
  end
end
