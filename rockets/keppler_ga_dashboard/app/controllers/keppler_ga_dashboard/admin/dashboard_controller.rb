require 'google/api_client'

module KepplerGaDashboard
  module Admin

    # DashboarController
    class DashboardController < ::ApplicationController
      layout 'keppler_ga_dashboard/admin/layouts/application'
      before_action :authenticate_admin_user
      before_action :dashboard_access, only: [:analytics]
      before_action :set_apparience_colors

      def analytics
        # set up a client instance
        client = ::Google::APIClient.new(
          application_name: 'keppler',
          application_version: '1'
        )

        client.authorization = Signet::OAuth2::Client.new(
          options
        ).tap(&:fetch_access_token!)

        @access_token = client.authorization.fetch_access_token!['access_token']

        gon.color = @color
      rescue StandardError
        render :connection_error
      end

      # Options for authenticate
      def options
        { token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          audience: 'https://accounts.google.com/o/oauth2/token',
          scope: 'https://www.googleapis.com/auth/analytics.readonly',
          issuer: Rails.application.secrets.ga_auth.fetch(
            :service_account_email_address
          ),
          signing_key: Google::APIClient::KeyUtils.load_from_pkcs12(
            file_key, 'notasecret'
          )
        }
      end

      def set_apparience_colors
        variables_file = File.readlines(style_file)
        @color = ""
        variables_file.each { |line| @color = line[15..21] if line.include?('$keppler-color') }
      end

      def style_file
        "#{Rails.root}/app/assets/stylesheets/admin/utils/_variables.scss"
      end

      # get .p12 File for authenticate token
      def file_key
        File.join(
          Rails.root,
          'config',
          'gaAuth',
          Rails.application.secrets.ga_auth.fetch(:file_key_name)
        )
      end

      def authenticate_admin_user
        if !current_user
          redirect_to '/403'
        end
      end
    end
  end
end
