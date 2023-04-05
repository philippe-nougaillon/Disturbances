require 'rails_helper'

RSpec.describe "services/index", type: :view do
  before(:each) do
    assign(:services, [
      Service.create!(
        train: "Train",
        horaire: "Horaire",
        destination: "Destination"
      ),
      Service.create!(
        train: "Train",
        horaire: "Horaire",
        destination: "Destination"
      )
    ])
  end

  it "renders a list of services" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Train".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Horaire".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Destination".to_s), count: 2
  end
end
