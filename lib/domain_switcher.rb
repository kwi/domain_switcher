module DomainSwitcher
  autoload :Middleware,   'domain_switcher/middleware'
  autoload :ConfigLoader, 'domain_switcher/config_loader'
  autoload :Website,      'domain_switcher/website'
  autoload :Domain,       'domain_switcher/domain'
  autoload :Helper,       'domain_switcher/helper'
end

current_path = File.dirname(__FILE__)
require File.join(current_path, 'domain_switcher/rails') if defined?(Rails)
