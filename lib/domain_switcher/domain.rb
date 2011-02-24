module DomainSwitcher
  class Domain
    include ConfigBuilder

    attr_reader :website
    attr_reader :domain

    def initialize(website, domain, conf = {})
      @website = website
      @domain = domain
      build_config!(conf)
    end
    
    def cookie_domain
      @cookie_domain ||= domain.split('.').last(2).join('.')
    end

  end
end