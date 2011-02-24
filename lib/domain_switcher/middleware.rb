module DomainSwitcher
  class Middleware

    def initialize(app)
      @app = app
      @config = DomainSwitcher::ConfigLoader.new
      @scanner = DomainSwitcher::Scanner.new(@config.domains)
    end
    
    def call(env)
      domain = @scanner.scan_domain(ENV['HTTP_HOST']) || @config.default_domain

      DomainSwitcher::Helper::switch(domain)
      DomainSwitcher::Cache::switch(domain.website)
      env = DomainSwitcher::Cookie::switch(domain, env)

      @app.call(env)
    end

  end
end