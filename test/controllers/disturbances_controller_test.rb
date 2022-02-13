require "test_helper"

class DisturbancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @disturbance = disturbances(:one)
  end

  test "should get index" do
    get disturbances_url
    assert_response :success
  end

  test "should get new" do
    get new_disturbance_url
    assert_response :success
  end

  test "should create disturbance" do
    assert_difference("Disturbance.count") do
      post disturbances_url, params: { disturbance: { date: @disturbance.date, destination: @disturbance.destination, départ: @disturbance.départ, raison: @disturbance.raison, train: @disturbance.train, voie: @disturbance.voie } }
    end

    assert_redirected_to disturbance_url(Disturbance.last)
  end

  test "should show disturbance" do
    get disturbance_url(@disturbance)
    assert_response :success
  end

  test "should get edit" do
    get edit_disturbance_url(@disturbance)
    assert_response :success
  end

  test "should update disturbance" do
    patch disturbance_url(@disturbance), params: { disturbance: { date: @disturbance.date, destination: @disturbance.destination, départ: @disturbance.départ, raison: @disturbance.raison, train: @disturbance.train, voie: @disturbance.voie } }
    assert_redirected_to disturbance_url(@disturbance)
  end

  test "should destroy disturbance" do
    assert_difference("Disturbance.count", -1) do
      delete disturbance_url(@disturbance)
    end

    assert_redirected_to disturbances_url
  end
end
