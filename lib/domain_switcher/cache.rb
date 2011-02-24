module DomainSwitcher
  module Cache
    
    def self.switch(website)
      
      namespace = website.default_domain
      #Thread.current[:current_mkd_cache_namespace] = namespace
      if (c = Rails.cache)
        if !$mkd_cache_systems[namespace]
          RAILS_DEFAULT_LOGGER.info "Create new cache system for namespace : #{c.class} | #{namespace}" 
          $mkd_cache_systems[namespace] = if (c.class.to_s == 'ActiveSupport::Cache::LibmemcachedStore' or c.is_a? ActiveSupport::Cache::MemCacheStore)
            c.class.new(RConf.configuration.cache_store[1], :namespace => namespace, :prefix_key => namespace, :raw => false)
          elsif c.is_a? ActiveSupport::Cache::FileStore
            c.class.new("tmp/cache/#{namespace}")
          else
            c
          end
        end
        Thread.current[:current_mkd_cache_namespace] = namespace
        ActionController::Caching.send(:class_variable_set, :@@cache_store, (Thread.current[:current_mkd_cache_system] = $mkd_cache_systems[namespace]))
      end
      
    end

  end
end