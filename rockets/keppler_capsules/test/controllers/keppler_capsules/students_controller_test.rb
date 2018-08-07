require 'test_helper'

module KepplerCapsules
  class StudentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @student = keppler_capsules_students(:one)
    end

    test "should get index" do
      get students_url
      assert_response :success
    end

    test "should get new" do
      get new_student_url
      assert_response :success
    end

    test "should create student" do
      assert_difference('Student.count') do
        post students_url, params: { student: { deleted_at: @student.deleted_at, description: @student.description, name: @student.name, position: @student.position } }
      end

      assert_redirected_to student_url(Student.last)
    end

    test "should show student" do
      get student_url(@student)
      assert_response :success
    end

    test "should get edit" do
      get edit_student_url(@student)
      assert_response :success
    end

    test "should update student" do
      patch student_url(@student), params: { student: { deleted_at: @student.deleted_at, description: @student.description, name: @student.name, position: @student.position } }
      assert_redirected_to student_url(@student)
    end

    test "should destroy student" do
      assert_difference('Student.count', -1) do
        delete student_url(@student)
      end

      assert_redirected_to students_url
    end
  end
end
