require 'test_helper'

class TestModulesControllerTest < ActionController::TestCase
  setup do
    @test_module = test_modules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:test_modules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create test_module" do
    assert_difference('TestModule.count') do
      post :create, test_module: { age: @test_module.age, name: @test_module.name, phone: @test_module.phone, photo: @test_module.photo, public: @test_module.public, weight: @test_module.weight }
    end

    assert_redirected_to test_module_path(assigns(:test_module))
  end

  test "should show test_module" do
    get :show, id: @test_module
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @test_module
    assert_response :success
  end

  test "should update test_module" do
    patch :update, id: @test_module, test_module: { age: @test_module.age, name: @test_module.name, phone: @test_module.phone, photo: @test_module.photo, public: @test_module.public, weight: @test_module.weight }
    assert_redirected_to test_module_path(assigns(:test_module))
  end

  test "should destroy test_module" do
    assert_difference('TestModule.count', -1) do
      delete :destroy, id: @test_module
    end

    assert_redirected_to test_modules_path
  end
end
