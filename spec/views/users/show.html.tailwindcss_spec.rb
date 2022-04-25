require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      nom: "Nom",
      prénom: "Prénom",
      email: "Email",
      admin: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nom/)
    expect(rendered).to match(/Prénom/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/false/)
  end
end
