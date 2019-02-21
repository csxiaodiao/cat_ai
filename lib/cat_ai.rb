require "cat_ai/version"
require 'rest-client'
require 'json'

module CatAi
  module Api
    class Configuration
      attr_accessor :app_id, :app_key, :post_url
      def initialize
        @app_id = ''
        @app_key = ''
        @post_url = ''
      end
    end

    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      def create_params(mode, content, kw, src, dst)
        body = {
          wenzhang: content, 
          v: mode, 
          kw: kw, 
          src: src, 
          dst: dst, 
          key: configuration.app_key
        }.compact

        body
      end

      # model 1 smooth, v2 height, v3 highest

      def reedit(mode, content)
        body =  create_params(mode, content).to_json
        single_sender(body)
      end
      
      # src original keywords
      # dst replace keywords
      # kw 1 list 2 add 3 delete

      def keywords(kw, src, drc)
        params = {params: create_params(kw, src, drc)}
        get_single_sender(params)
      end

      def select(count)
        params = {parmas: {count: count}}
        get_single_sender(params)
      end

      def get_single_sender(params)
        header = {content_type: :json, accept: :json}
        params = params.merge(header).to_json
        response = RestClient.get(configuration.post_url, params)
      end


      def single_sender(body)
        header = {content_type: :json, accept: :json}
        response = RestClient.post(configuration.post_url, body, header)
      end


    end

  end
end
