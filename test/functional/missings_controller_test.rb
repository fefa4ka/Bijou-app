require 'test_helper'

class MissingsControllerTest < ActionController::TestCase
  setup do
    @missing = missings(:piere)
    @update = {
      :name => "Петров Водкин",
      :description => "История пропажи",
      :image_url => "001.jpg"
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:missings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create missing" do
    assert_difference('Missing.count') do
      post :create, :missing => @update
    end

    assert_redirected_to missing_path(assigns(:missing))
  end

  test "should show missing" do
    get :show, :id => @missing.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @missing.to_param
    assert_response :success
  end

  test "should update missing" do
    put :update, :id => @missing.to_param, :missing => @update
    assert_redirected_to missing_path(assigns(:missing))
  end

  test "should destroy missing" do
    assert_difference('Missing.count', -1) do
      delete :destroy, :id => @missing.to_param
    end

    assert_redirected_to missings_path
  end
end
