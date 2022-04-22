require 'rails_helper'

RSpec.describe "sources/index", type: :view do
  before(:each) do
    assign(:sources, [
      Source.create!(
        url: "Url",
        gare: "Gare",
        sens: "Sens"
      ),
      Source.create!(
        url: "Url",
        gare: "Gare",
        sens: "Sens"
      )
    ])
  end

  it "renders a list of sources" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Gare".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Sens".to_s), count: 2
  end
end
