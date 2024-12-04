require "test_helper"

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test "should return bad request when no data is sent" do
    post purchases_path

    assert_response :bad_request
  end

  test "should return unprocessable_entity when string is sent instead of integer" do
    invalid_line = "0000000023                                  Logan Lynch"\
                   "0000000253000000000S      322.1220210523"

    post purchases_path, params: invalid_line
    assert_response :unprocessable_entity
  end

  test "should return unprocessable_entity when invalid string date is sent" do
    invalid_purchase_data = "0000000070                              Palmer Prosacco00000007530000000003     1836.7420210398\n0000000075                                  Bobbie Batz00000007980000000002     1578.5720211116\n0000000049                               Ken Wintheiser00000005230000000003      586.7420210903\n0000000014                                 Clelia Hills00000001460000000001      673.4920211125\n0000000057                          Elidia Gulgowski IV00000006200000000000     1417.2520210919\n0000000080                                 Tabitha Kuhn00000008770000000003      817.1320210612"

    post purchases_path, params: invalid_purchase_data
    assert_response :unprocessable_entity
  end

  test "should respond ok when valid data is sent" do
    valid_purchase_data = "0000000023                                  Logan Lynch00000002530000000002      322.1220210523"

    post purchases_path, params: valid_purchase_data

    assert_response :success
  end

  test "should gather 2 purchases from same client and order on products array" do
    same_client_purchases = "0000000080                                 Tabitha Kuhn00000008770000000003      817.1320210612\n0000000080                                 Tabitha Kuhn00000008770000000004      320.4520210612"

    post purchases_path, params: same_client_purchases

    assert_equal 2, response.parsed_body.dig(0, "orders", 0, "products").count
  end

  test "should sum product values from same order" do
    same_client_purchases = "0000000080                                 Tabitha Kuhn00000008770000000003      817.1320210612\n0000000080                                 Tabitha Kuhn00000008770000000004      320.4520210612"

    post purchases_path, params: same_client_purchases

    assert_equal (817.13 + 320.45), response.parsed_body.dig(0, "orders", 0, "total")
  end
end
