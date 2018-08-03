require 'test_helper'

module KepplerCapsules
  class CpslPeopleControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @cpsl_person = keppler_capsules_cpsl_people(:one)
    end

    test "should get index" do
      get cpsl_people_url
      assert_response :success
    end

    test "should get new" do
      get new_cpsl_person_url
      assert_response :success
    end

    test "should create cpsl_person" do
      assert_difference('CpslPerson.count') do
        post cpsl_people_url, params: { cpsl_person: { deleted_at: @cpsl_person.deleted_at, name: @cpsl_person.name, phone: @cpsl_person.phone, position: @cpsl_person.position } }
      end

      assert_redirected_to cpsl_person_url(CpslPerson.last)
    end

    test "should show cpsl_person" do
      get cpsl_person_url(@cpsl_person)
      assert_response :success
    end

    test "should get edit" do
      get edit_cpsl_person_url(@cpsl_person)
      assert_response :success
    end

    test "should update cpsl_person" do
      patch cpsl_person_url(@cpsl_person), params: { cpsl_person: { deleted_at: @cpsl_person.deleted_at, name: @cpsl_person.name, phone: @cpsl_person.phone, position: @cpsl_person.position } }
      assert_redirected_to cpsl_person_url(@cpsl_person)
    end

    test "should destroy cpsl_person" do
      assert_difference('CpslPerson.count', -1) do
        delete cpsl_person_url(@cpsl_person)
      end

      assert_redirected_to cpsl_people_url
    end
  end
end
