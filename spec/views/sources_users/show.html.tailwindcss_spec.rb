require 'rails_helper'

RSpec.describe "sources_users/show", type: :view do
  before(:each) do
    @sources_user = assign(:sources_user, SourcesUser.create!(
      source_id: 2,
      user_id: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
