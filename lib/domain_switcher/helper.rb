module DomainSwitcher
  module Helper
    
    def domain
      Thread.current[:domain_switcher_domain]
    end
    
    def website
      Thread.current[:domain_switcher_website]
    end
    
  end
end