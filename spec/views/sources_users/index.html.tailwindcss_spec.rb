require 'rails_helper'

RSpec.describe "sources_users/index", type: :view do
  before(:each) do
    assign(:sources_users, [
      SourcesUser.create!(
        source_id: 2,
        user_id: 3
      ),
      SourcesUser.create!(
        source_id: 2,
        user_id: 3
      )
    ])
  end

  it "renders a list of sources_users" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
