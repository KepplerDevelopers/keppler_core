# Devise module authenticate
module Devise
  # SessionsController
  class KepplerSessionsController < DeviseController
    prepend_before_action :require_no_authentication, only: [:new, :create]
    prepend_before_action :allow_params_authentication!, only: :create
    prepend_before_action :verify_signed_out_user, only: :destroy
    prepend_before_action :session_history, only: [:create, :destroy]
    prepend_before_action only: [:create, :destroy] do
      request.env['devise.skip_timeout'] = true
    end

    before_action :validate_admin_code, only: [:new]

    # GET /resource/sign_in
    def new
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      yield resource if block_given?
      respond_with(resource, serialize_options(resource))
    end

    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options(params))
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: admin_root_path
    end

    # DELETE /resource/sign_out
    def destroy
      signed_out =
        (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      if signed_out && is_flashing_format?
        set_flash_message :notice, :signed_out
      end
      yield if block_given?
      respond_to_on_destroy
    end

    protected

    def sign_in_params
      devise_parameter_sanitizer.sanitize(:sign_in)
    end

    def serialize_options(resource)
      methods = resource_class.authentication_keys.dup
      methods = methods.keys if methods.is_a?(Hash)
      methods << :password if resource.respond_to?(:password)
      { methods: methods, only: [:password] }
    end

    def auth_options(params)
      if params[:user].has_key?(:path)
        { scope: resource_name, recall: params[:user][:path] }
      else
        { scope: resource_name, recall: "#{controller_path}#new" }
      end
    end

    def translation_scope
      'devise.sessions'
    end

    private

    def validate_admin_code
      unless params[:admin_code].eql?(Appearance.first.admin_code)
        redirect_to main_app.not_authorized_path
      end
    end

    # Check if there is no signed in user before doing the sign out.
    #
    # If there is no signed in user, it will set the flash message and redirect
    # to the after_sign_out path.
    def verify_signed_out_user
      if all_signed_out?
        set_flash_message :notice, :already_signed_out if is_flashing_format?

        respond_to_on_destroy
      end
    end

    def all_signed_out?
      users = Devise.mappings.keys.map do |s|
        warden.user(scope: s, run_callbacks: false)
      end

      users.all?(&:blank?)
    end

    # Create history to session
    def session_history
      PublicActivity::Activity.create(
        trackable_type: controller_name.singularize.humanize,
        key: "#{controller_name.singularize.downcase}.#{action_name}",
        owner: current_user
      )
    end

    def respond_to_on_destroy
      # We actually need to hardcode this as Rails default responder doesn't
      # support returning empty response on GET request
      respond_to do |format|
        format.all { head :no_content }
        format.any(*navigational_formats) do
          redirect_to after_sign_out_path_for(resource_name)
        end
      end
    end
  end
end
