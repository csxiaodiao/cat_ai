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

      def create_params(**opt)
        params = {
          v: opt[:mode], 
          kw: opt[:kw], 
          src: opt[:src], 
          dst: opt[:dst], 
          count: opt[:count],
          key: configuration.app_key
        }.compact

        params
      end

      def create_payload(content)
        {wenzhang: content}
      end

      # model 1 smooth, v2 height, v3 highest

      def reedit(mode, content)
        params =  {params: create_params(mode: mode)}
        payload =  create_payload(content)

        single_sender(params, payload)
      end
      
      # src original keywords
      # dst replace keywords
      # kw 1 list 2 add 3 delete

      def keywords(**opt)
        params = {params: create_params(kw: opt[:kw], src: opt[:src], drc: opt[:drc])}

        get_single_sender(params)
      end

      def select(count)
        params = {params: create_params(count: count)}
        get_single_sender(params)
      end

      def get_single_sender(params)    
        response = RestClient.get(configuration.post_url, params)
      end


      def single_sender(params, payload)
        response = RestClient.post(configuration.post_url, payload, params)
      end


    end

  end
end
