require 'test_helper'

class TestModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_module = test_modules(:one)
  end

  test "should get index" do
    get test_modules_url
    assert_response :success
  end

  test "should get new" do
    get new_test_module_url
    assert_response :success
  end

  test "should create test_module" do
    assert_difference('TestModule.count') do
      post test_modules_url, params: { test_module: { deleted_at: @test_module.deleted_at, image: @test_module.image, name: @test_module.name, position: @test_module.position } }
    end

    assert_redirected_to test_module_url(TestModule.last)
  end

  test "should show test_module" do
    get test_module_url(@test_module)
    assert_response :success
  end

  test "should get edit" do
    get edit_test_module_url(@test_module)
    assert_response :success
  end

  test "should update test_module" do
    patch test_module_url(@test_module), params: { test_module: { deleted_at: @test_module.deleted_at, image: @test_module.image, name: @test_module.name, position: @test_module.position } }
    assert_redirected_to test_module_url(@test_module)
  end

  test "should destroy test_module" do
    assert_difference('TestModule.count', -1) do
      delete test_module_url(@test_module)
    end

    assert_redirected_to test_modules_url
  end
end
