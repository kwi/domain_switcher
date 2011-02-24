module DomainSwitcher
  module Cache
    
    def self.init
      $domain_switcher_cache_systems = {}
    end

    def self.switch(website)
      namespace = website.cache_prefix || website.symbol

      if (c = RAILS_CACHE)
        if !$domain_switcher_cache_systems.key?(namespace)
          Rails.logger.info "DomainSwitcher: Create new cache system for namespace : #{c.class} | #{namespace}" 

          # MemcachedStore => Tested and working with Memcached gem only
          $domain_switcher_cache_systems[namespace] = if ActiveSupport::Cache::MemCacheStore === c
            d = RAILS_CACHE.instance_variable_get('@data')
            if d.prefix_key == namespace
              Rails.logger.info "DomainSwitcher: Use existing cache => namespace is the same: #{namespace}"
              RAILS_CACHE
            else
              c.class.new(d.instance_variable_get('@servers'), d.instance_variable_get('@options').merge(:namespace => namespace, :prefix_key => namespace))
            end
          elsif c.is_a? ActiveSupport::Cache::FileStore
            c.class.new("tmp/cache/#{namespace}")
          else
            c
          end
        end
        ActionController::Caching.send(:class_variable_set, :@@cache_store, (Thread.current[:domain_switcher_cache] = $domain_switcher_cache_systems[namespace]))
      end

    end

  end
end