require 'test_helper'

class MsgsControllerTest < ActionController::TestCase
  setup do
    @msg = msgs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:msgs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create msg" do
    assert_difference('Msg.count') do
      post :create, msg: { body: @msg.body, room: @msg.room, sender: @msg.sender }
    end

    assert_redirected_to msg_path(assigns(:msg))
  end

  test "should show msg" do
    get :show, id: @msg
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @msg
    assert_response :success
  end

  test "should update msg" do
    patch :update, id: @msg, msg: { body: @msg.body, room: @msg.room, sender: @msg.sender }
    assert_redirected_to msg_path(assigns(:msg))
  end

  test "should destroy msg" do
    assert_difference('Msg.count', -1) do
      delete :destroy, id: @msg
    end

    assert_redirected_to msgs_path
  end
end
