module V1
  class BaseController < ::ApplicationController

    include Epublishing::V1::ErrorHandling
    include Epublishing::V1::Database

    before_filter :connect_customer   if Rails.env != 'test'
    layout false

    private

    # Private: Switch customer database.
    #
    #
    # Returns database object.
    def connect_customer
      Epublishing::V1::Database::DbConnect.connect_customer(@customer)
    end

    def parse_request
        @json = JSON.parse(request.body.read)
    end

    def render_error(error)
        render(json: error, status: error.status)
    end
  end
end

