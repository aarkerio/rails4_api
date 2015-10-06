# GPLv3 Manuel Montoya 2015

class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session
  before_filter :authentication_check

  def routing_error
    redirect_api_issue || routing_error_from_epublishing
  end

  private

  def redirect_api_issue
    return render json: { ErrorMesage: 'API routing_error Error' }
  end

  def authentication_check
    authenticate_or_request_with_http_basic do |user, password|
      hashed_pwd = Digest::SHA256.hexdigest(password)
      @customer   = Customer.where(api_key: user, secret_key: hashed_pwd).first
      @customer.present?
    end
  end
end

