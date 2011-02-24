module DomainSwitcher
  class Website
    
    attr_reader :name
    attr_reader :symbol
    attr :default_domain, true
    
    def initialize(name, symbol, conf, domains = [])
      @name = name
      @symbol = symbol
      @conf = conf
      @domains = domains
    end
    
    def <<(domain)
      domains << []
    end

  end
end