module DomainSwitcher
  autoload :Middleware,    'domain_switcher/middleware'
  autoload :ConfigLoader,  'domain_switcher/config_loader'
  autoload :ConfigBuilder, 'domain_switcher/config_builder'
  autoload :Website,       'domain_switcher/website'
  autoload :Domain,        'domain_switcher/domain'
  autoload :Helper,        'domain_switcher/helper'
  autoload :Scanner,       'domain_switcher/scanner'
  autoload :Cache,         'domain_switcher/cache'
  autoload :Cookie,        'domain_switcher/cookie'
  autoload :Logger,        'domain_switcher/logger'
end

current_path = File.dirname(__FILE__)
require File.join(current_path, 'domain_switcher/rails')
