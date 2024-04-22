require "test_helper"

class ValordosesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valordose = valordoses(:one)
  end

  test "should get index" do
    get valordoses_url
    assert_response :success
  end

  test "should get new" do
    get new_valordose_url
    assert_response :success
  end

  test "should create valordose" do
    assert_difference("Valordose.count") do
      post valordoses_url, params: { valordose: { value: @valordose.value } }
    end

    assert_redirected_to valordose_url(Valordose.last)
  end

  test "should show valordose" do
    get valordose_url(@valordose)
    assert_response :success
  end

  test "should get edit" do
    get edit_valordose_url(@valordose)
    assert_response :success
  end

  test "should update valordose" do
    patch valordose_url(@valordose), params: { valordose: { value: @valordose.value } }
    assert_redirected_to valordose_url(@valordose)
  end

  test "should destroy valordose" do
    assert_difference("Valordose.count", -1) do
      delete valordose_url(@valordose)
    end

    assert_redirected_to valordoses_url
  end
end
