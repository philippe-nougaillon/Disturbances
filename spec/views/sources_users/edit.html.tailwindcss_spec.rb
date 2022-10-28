require 'rails_helper'

RSpec.describe "sources_users/edit", type: :view do
  before(:each) do
    @sources_user = assign(:sources_user, SourcesUser.create!(
      source_id: 1,
      user_id: 1
    ))
  end

  it "renders the edit sources_user form" do
    render

    assert_select "form[action=?][method=?]", sources_user_path(@sources_user), "post" do

      assert_select "input[name=?]", "sources_user[source_id]"

      assert_select "input[name=?]", "sources_user[user_id]"
    end
  end
end
