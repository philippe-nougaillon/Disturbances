require 'rails_helper'

RSpec.describe "sources_users/new", type: :view do
  before(:each) do
    assign(:sources_user, SourcesUser.new(
      source_id: 1,
      user_id: 1
    ))
  end

  it "renders new sources_user form" do
    render

    assert_select "form[action=?][method=?]", sources_users_path, "post" do

      assert_select "input[name=?]", "sources_user[source_id]"

      assert_select "input[name=?]", "sources_user[user_id]"
    end
  end
end
