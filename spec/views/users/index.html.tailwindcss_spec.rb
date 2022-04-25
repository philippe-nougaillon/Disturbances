require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        nom: "Nom",
        prénom: "Prénom",
        email: "Email",
        admin: false
      ),
      User.create!(
        nom: "Nom",
        prénom: "Prénom",
        email: "Email",
        admin: false
      )
    ])
  end

  it "renders a list of users" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Nom".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Prénom".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
