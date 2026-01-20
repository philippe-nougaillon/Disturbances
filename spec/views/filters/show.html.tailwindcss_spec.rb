require 'rails_helper'

RSpec.describe "filters/show", type: :view do
  before(:each) do
    @filter = assign(:filter, Filter.create!(
      user: nil,
      name: "Name",
      trains: "Trains"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Trains/)
  end
end
