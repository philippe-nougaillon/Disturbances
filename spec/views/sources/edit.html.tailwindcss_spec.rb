require 'rails_helper'

RSpec.describe "sources/edit", type: :view do
  before(:each) do
    @source = assign(:source, Source.create!(
      url: "MyString",
      gare: "MyString",
      sens: "MyString"
    ))
  end

  it "renders the edit source form" do
    render

    assert_select "form[action=?][method=?]", source_path(@source), "post" do

      assert_select "input[name=?]", "source[url]"

      assert_select "input[name=?]", "source[gare]"

      assert_select "input[name=?]", "source[sens]"
    end
  end
end
