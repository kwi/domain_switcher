module DomainSwitcher
  class Website
    include ConfigBuilder

    attr_reader :name
    attr_reader :symbol
    attr_reader :domains
    attr :default_domain, true
    
    def initialize(name, symbol, conf = {}, domains = [])
      @name = name
      @symbol = symbol
      @domains = domains
      build_config!(conf)
    end
    
    def <<(domain)
      @domains << domain
    end

  end
end