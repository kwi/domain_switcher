# Override the default Rails.cache method in order to user the current memcache store
module Rails
  class << self
    def cache
      Thread.current[:domain_switcher_cache] || RAILS_CACHE
    end
  end
end

ActionController::Base.send   :include, MkdWebsite::Helper
ActionView::Base.send         :include, MkdWebsite::Helper