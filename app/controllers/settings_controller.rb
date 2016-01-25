#Generado con Keppler.
class SettingsController < ApplicationController  
  before_filter :authenticate_user!
  layout 'admin/application'
  load_and_authorize_resource
  before_action :set_setting, only: [:edit, :update]

  # GET /settings/1/edit
  def edit
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to settings_path(@render), notice: t('keppler.messages.successfully.updated', model: "#{t("keppler.header_information.setting.#{@render}")}") 
    else
      render :edit
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
       @setting = Setting.first
       @render = params[:config]
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
      params.require(:setting).permit(:name, :description, :logo, :favicon)
    end

    def show_history
      current_user.roles.each do |role|
        if role.name.eql?("admin")
          @activities = PublicActivity::Activity.where(trackable_type: 'Setting').order("created_at desc").limit(50)
        else
          @activities = PublicActivity::Activity.where("trackable_type = 'Setting' and owner_id=#{current_user.id}").order("created_at desc").limit(50)
        end
      end
    end
end
