require 'rails_helper'

RSpec.describe "sources/new", type: :view do
  before(:each) do
    assign(:source, Source.new(
      url: "MyString",
      gare: "MyString",
      sens: "MyString"
    ))
  end

  it "renders new source form" do
    render

    assert_select "form[action=?][method=?]", sources_path, "post" do

      assert_select "input[name=?]", "source[url]"

      assert_select "input[name=?]", "source[gare]"

      assert_select "input[name=?]", "source[sens]"
    end
  end
end
