require "test_helper"

class PurchaseTest < ActiveSupport::TestCase
  setup do
    @valid_line = "0000000023                                  Logan Lynch"\
                  "00000002530000000002      322.1220210523"
  end

  test "should be valid when contain all required data" do
    assert Purchase.new(@valid_line).valid?
  end

  test "should be invalid when null" do
    assert_not Purchase.new(nil).valid?
  end

  test "should be invalid when empty hash" do
    assert_not Purchase.new({}).valid?
  end

  test "should be invalid when invalid date" do
    invalid_date_line = "0000000023                                  Logan Lynch"\
                        "00000002530000000002      322.1220210593"
    assert !Purchase.new(invalid_date_line).valid?
  end

  # test "should be invalid when string sent instead of integer" do
  test "should be invalid when misses one required field" do
    invalid_line = "                                  Logan Lynch"\
                   "00000002530000000002      322.1220210503"
    assert_not Purchase.new(invalid_line).valid?
  end
end
