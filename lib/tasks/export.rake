# encoding: utf-8
require 'nokogiri'

namespace :jade do
  namespace :export do
    # This task exports all comments to an XML file, suitable for being imported
    # into Disqus.
    #
    # Command line arguments:
    #
    # EXPORT_PATH - File path to write the resulting XML to.
    #
    #
    # Example call:
    #
    #   rake jade:export:disqus EXPORT_PATH=/path/to/file.xml
    #
    #
    # See Disqus docs for more information:
    #
    #   https://help.disqus.com/customer/portal/articles/472150-custom-xml-import-format
    #
    desc 'Exports comments in XML for Disqus.'
    task disqus: :environment do
      puts 'Exporting comments. This can take a few minutes...'

      xml = Jade::Disqus.build_comments_xml
      IO.write(ENV['EXPORT_PATH'].to_s, xml)
      
      puts "Created XML file #{ENV['EXPORT_PATH']}"
    end
  end
end

module Jade
module Disqus
  class << self
    def build_comments_xml
      builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |xml|
        xml.rss(rss_attributes) do
          xml.channel do
            for_each_item_with_comments do |item|
              xml.item do
                add_item_elements(xml, item)
                add_comments(xml, item.comments.live)
              end
            end
          end
        end
      end

      builder.to_xml
    end

    private

    def rss_attributes
      { 'version' => '2.0', 
        'xmlns:content' => 'http://purl.org/rss/1.0/modules/content/',
        'xmlns:dsq' => 'http://www.disqus.com/',
        'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
        'xmlns:wp' => 'http://wordpress.org/export/1.0/' }
    end

    def for_each_item_with_comments
      articles_with_comments.find_each { |a| yield(a) }
      products_with_comments.find_each { |p| yield(p) }
    end

    def articles_with_comments
      Article.select('DISTINCT articles.*')
             .joins(:article_talk_backs)
             .merge(ArticleTalkBack.live.where(offensive: false))
    end

    def products_with_comments
      Product.select('DISTINCT products.*')
             .joins(:product_talk_backs)
             .merge(ProductTalkBack.live.where(offensive: false))
    end

    def add_item_elements(xml, item)
      xml.send('title_', item.headline)
      xml.send('link_', link(item))
      xml.send('content:encoded', '')
      xml.send('dsq:thread_identifier', thread_id(item))
      xml.send('wp:post_date_gmt', format_time(item.created_at))
      xml.send('wp:comment_status', 'open')
    end

    def add_comments(xml, comments)
      comments.each do |c| 
        xml.send('wp:comment') do
          xml.send('wp:comment_id', c.id)
          xml.send('wp:comment_author', c.user_name)
          xml.send('wp:comment_author_email', author_email(c))
          xml.send('wp:comment_author_url', '')
          xml.send('wp:comment_author_IP', c.remote_addr)
          xml.send('wp:comment_date_gmt', format_time(c.created_at))
          xml.send('wp:comment_content') { xml.cdata(c.body) }
          xml.send('wp:comment_approved', '1')
          xml.send('wp:comment_parent', parent_id(c))
        end
      end
    end

    def author_email(comment)
      # Disqus requires author email to be no longer than 75 characters. Return
      # only the first one from a list of emails.
      email = comment.user_email
      email.present? ? email.split(';').first : ''
    end

    def parent_id(comment)
      tree_path = comment.tree_path
      tree_path.present? ? tree_path.split(':').last : ''
    end

    def format_time(time)
      time.utc.strftime('%Y-%m-%d %H:%M:%S')
    end

    def link(item)
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.extend(ActionDispatch::Routing::PolymorphicRoutes)

      host_without_trailing_slash = Site::SITE_URL_BASE[0..-2]

      url_helpers.polymorphic_url(item, host: host_without_trailing_slash)
    end

    def thread_id(item)
      "#{item.class.name.downcase}-#{item.id}"
    end
  end
end
end
