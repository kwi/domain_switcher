require 'rubygems'
require 'rspec'
require 'logger'

module ActionController
  class Base
  end
  
  module Caching
  end
end

module ActionView
  class Base
  end
end

module ActiveRecord
  class Base
  end
end

module ActiveSupport
  module Cache
    class MemCacheStore
      def initialize(*args)
        @data = Memcached.new(*args)
      end
    end
    
    class Memcached  
      def initialize(servers, options = {})
        @servers = servers
        @options = options
      end
      
      def prefix_key
        @options[:prefix_key]
      end

    end
    
    class FileStore
    end
  end
end

module Rails
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end  
end

RAILS_CACHE = ActiveSupport::Cache::MemCacheStore.new(['localhost'], {:test_options => true, :prefix_key => 'first'})

require File.dirname(__FILE__) + '/../init.rb'