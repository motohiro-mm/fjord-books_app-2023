# frozen_string_literal: true

class User::NotAuthorized < StandardError
end

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from User::NotAuthorized, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    keys = %i[name postal_code address self_introduction avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys:)
    devise_parameter_sanitizer.permit(:account_update, keys:)
  end

  private

  def after_sign_in_path_for(_resource_or_scope)
    books_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def signed_in_root_path(_resource_or_scope)
    user_path(current_user)
  end

  def user_not_authorized
    render plain: '404 Not Found', status: 404
  end

  def check_authorization(report_or_comment)
    raise User::NotAuthorized unless report_or_comment.user == current_user
  end
end
