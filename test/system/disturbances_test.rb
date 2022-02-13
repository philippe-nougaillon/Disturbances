require "application_system_test_case"

class DisturbancesTest < ApplicationSystemTestCase
  setup do
    @disturbance = disturbances(:one)
  end

  test "visiting the index" do
    visit disturbances_url
    assert_selector "h1", text: "Disturbances"
  end

  test "should create disturbance" do
    visit disturbances_url
    click_on "New disturbance"

    fill_in "Date", with: @disturbance.date
    fill_in "Destination", with: @disturbance.destination
    fill_in "Départ", with: @disturbance.départ
    fill_in "Raison", with: @disturbance.raison
    fill_in "Train", with: @disturbance.train
    fill_in "Voie", with: @disturbance.voie
    click_on "Create Disturbance"

    assert_text "Disturbance was successfully created"
    click_on "Back"
  end

  test "should update Disturbance" do
    visit disturbance_url(@disturbance)
    click_on "Edit this disturbance", match: :first

    fill_in "Date", with: @disturbance.date
    fill_in "Destination", with: @disturbance.destination
    fill_in "Départ", with: @disturbance.départ
    fill_in "Raison", with: @disturbance.raison
    fill_in "Train", with: @disturbance.train
    fill_in "Voie", with: @disturbance.voie
    click_on "Update Disturbance"

    assert_text "Disturbance was successfully updated"
    click_on "Back"
  end

  test "should destroy Disturbance" do
    visit disturbance_url(@disturbance)
    click_on "Destroy this disturbance", match: :first

    assert_text "Disturbance was successfully destroyed"
  end
end
