require "test_helper"

class ArchivedOrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get archived_orders_index_url
    assert_response :success
  end
end
