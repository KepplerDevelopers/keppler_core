<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
module App
  # <%= controller_class_name %>Controller
  class FrontController < AppController
    <%- attributes.each do |attribute| -%>
      def <%= attribute.name %>
      end
    <%- end -%>
  end
end
<% end -%>
