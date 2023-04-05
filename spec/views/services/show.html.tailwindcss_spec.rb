require 'rails_helper'

RSpec.describe "services/show", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
      train: "Train",
      horaire: "Horaire",
      destination: "Destination"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Train/)
    expect(rendered).to match(/Horaire/)
    expect(rendered).to match(/Destination/)
  end
end
