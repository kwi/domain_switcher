module DomainSwitcher
  class Domain

    attr_reader :website
    attr_reader :domain

    def initialize(opts)
      @website = opts[:website]
      @domain = opts[:domain]
    end
    
    def cookie_domain
    end

  end
end