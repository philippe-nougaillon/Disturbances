require 'rails_helper'

RSpec.describe "filters/index", type: :view do
  before(:each) do
    assign(:filters, [
      Filter.create!(
        user: nil,
        name: "Name",
        trains: "Trains"
      ),
      Filter.create!(
        user: nil,
        name: "Name",
        trains: "Trains"
      )
    ])
  end

  it "renders a list of filters" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Trains".to_s), count: 2
  end
end
