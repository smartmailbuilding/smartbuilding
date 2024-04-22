require "application_system_test_case"

class ValordosesTest < ApplicationSystemTestCase
  setup do
    @valordose = valordoses(:one)
  end

  test "visiting the index" do
    visit valordoses_url
    assert_selector "h1", text: "Valordoses"
  end

  test "should create valordose" do
    visit valordoses_url
    click_on "New valordose"

    fill_in "Value", with: @valordose.value
    click_on "Create Valordose"

    assert_text "Valordose was successfully created"
    click_on "Back"
  end

  test "should update Valordose" do
    visit valordose_url(@valordose)
    click_on "Edit this valordose", match: :first

    fill_in "Value", with: @valordose.value
    click_on "Update Valordose"

    assert_text "Valordose was successfully updated"
    click_on "Back"
  end

  test "should destroy Valordose" do
    visit valordose_url(@valordose)
    click_on "Destroy this valordose", match: :first

    assert_text "Valordose was successfully destroyed"
  end
end
