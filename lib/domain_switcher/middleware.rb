module DomainSwitcher
  class Middleware

    def initialize(app, config = nil)
      @app = app
      @config = config || DomainSwitcher::ConfigLoader.new
      @scanner = DomainSwitcher::Scanner.new(@config.domains)
      
      DomainSwitcher::Cache.init
    end

    def call(env)
      domain = @scanner.scan_domain(env['HTTP_HOST']) || @config.default_domain

      Rails.logger.debug "DomainSwitcher: Switch context for domain: #{domain.domain} (#{domain.website.name})"

      Thread.current[:domain_switcher_domain] = domain
      Thread.current[:domain_switcher_website] = domain.website

      DomainSwitcher::Cache::switch(domain.website)
      env = DomainSwitcher::Cookie::switch(domain, env)
      
      @app.call(env)
    end

  end
end