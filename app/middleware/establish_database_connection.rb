# Purpose and Explanation: `doc/Multi-Tenant_Database.md`
require 'active_record'
require 'net/http'
require 'json'

class EstablishDatabaseConnection
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end

  def connect(customer)
    make_connection(customer)
  end

  private

  def make_connection(customer)
    params = build_connection(customer)
    ActiveRecord::Base.establish_connection(params)
  end

  def build_connection(customer)
    return unless Rails.application.config.active_multi_tenant_database

    adapter = ActiveRecord::Base.configurations[Rails.env]['adapter']
    Rails.logger.debug "#####################>> Adapter #{adapter}"
    Rails.logger.debug "#####################>> active_multi_tenant_database #{Rails.application.config.active_multi_tenant_database}"

    params = { adapter: adapter, username: customer.db_user, password: customer.db_pwd }
    case Rails.env
    when 'development'
      params[:database] = "#{customer.db_name}_development"
      params[:host]     = 'localhost'
    when 'staging'
      params[:database] = "#{customer.db_name}_staging"
      params[:host]     = customer.db_staging
    when 'production'
      params[:database] = "#{customer.db_name}_production"
      params[:host]     = customer.db_production
    end
    params
  end

  def translator
    TranslateShortnameToClient.new
  end

  def retrieve_credentials
    CredentialCache.new(RetrieveCredentials.new)
  end

  class CredentialCache
    attr_reader :retrieve

    def initialize(retrieve)
      @retrieve = retrieve
    end

    def for(client)
      Rails.cache.fetch(client.domain) do
        retrieve.for(client)
      end
    end
  end

  class TranslateShortnameToClient
    SUBDOMAIN_SITES = %w[inspections-fdanews devices-fdanews]

    Client = Struct.new(:domain) do
      def staging?
        domain.end_with?('stage.epublishing.com')
      end
    end

    def fetch(domainname)
      return Client.new("localhost")
      matchdata = domainname.match(/^(.*)\.enhanced-admin(-stage)?\.epublishing\.com$/)
      fail 'Invalid domain name: #{domainname} does not match pattern' unless matchdata
      hostname = matchdata[1]

      if domainname.end_with?('.enhanced-admin-stage.epublishing.com')
        Client.new("#{hostname}-stage.epublishing.com")
      elsif SUBDOMAIN_SITES.include?(hostname)
        hostname = hostname.sub("-", '.')
        Client.new("#{hostname}.com")
      elsif hostname == 'creditunionmagazine'
        Client.new('news.cuna.org')
      else
        Client.new("www.#{hostname}.com")
      end
    end
  end

  class RetrieveCredentials
    def for(client)
      return JSON.parse({dbname: 'ibj', username: 'ibj', password: ''})
      uri = URI("http://#{client.domain}/api/database/credentials")
      req = Net::HTTP::Get.new(uri.request_uri)
      req['Host'] = uri.host
      req['Authorization'] = %Q(EPUBLISHING-AUTH username="jade-admin", key="sqlXrnfCanaHXToqkBDYeLD34VwrNoAJ")

      cache_servers = if client.staging?
                        %W(cache-stage-1.cloud.epub.net)
                      else
                        %W(cache-3.cloud.epub.net cache-4.cloud.epub.net)
                      end

      res = cache_servers.shuffle.each do |cache_server|
        res = begin
                Net::HTTP.start(cache_server, 80) do |http|
                  http.open_timeout = 1
                  http.read_timeout = 2
                  http.request(req)
                end
              rescue Timeout::Error
                :credentials_could_not_be_found
              end

        break res if res.is_a?(Net::HTTPSuccess)
      end

      if res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)
      else
        fail "Could not establish connection to #{uri}"
      end
    end
  end
end
