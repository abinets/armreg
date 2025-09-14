class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  include Accounts::SubscriptionStatus
  include ActiveStorage::SetCurrent
  include Authentication
  include Authorization
  include DeviceFormat
  include Pagy::Backend
  include SetCurrentRequestDetails
  include SetLocale
  include Sortable
  include Users::AgreementUpdates
  include Users::NavbarNotifications
  include Users::Sudo
  include Users::TimeZone

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user!, unless: :devise_controller?

  private

  def record_not_found
    redirect_to root_path, alert: "The requested record could not be found."
  end

end
