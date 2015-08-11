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

    if Rails.env != 'test'
      db = { adapter: 'mysql2', username: 'api_epub', password: 'c4SExA8J' }
      case Rails.env
      when 'local'
        db[:database] = 'api_epub_local'
        db[:host]     = 'localhost'
      when 'staging'
        db[:database] = 'api_epub_staging'
        db[:host]     = 'rails-stage-app-1.cloud.epub.net'
      when 'production'
        db[:database] = 'api_epub_production'
        db[:host]     = 'rails-app-1.cloud.epub.net'
      end
      ActiveRecord::Base.establish_connection(db)
    end

    authenticate_or_request_with_http_basic do |user, password|
      hashed_pwd = Digest::SHA256.hexdigest(password)
      @customer   = Customer.where(api_key: user, secret_key: hashed_pwd).first
      @customer.present?
    end
  end
end

