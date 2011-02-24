module DomainSwitcher
  class Scanner

    @domain_cache = {}
    
    def initialize(domains)
      @domains = domains
    end
    
    def scan_domain(host)
      return @@domain_cache[host] if @@domain_cache.key?(host)
      
      dom = nil
      nbdot = nil
      # Iterate domain and find the appropriate domain
      domains.each do |domain|
        if dot = d.rindex(domain.domain)
          if !nbdot or dot < nbdot
            nbdot = dot
            dom = domain
          end
        end
      end

      @@domain_cache[host] ||= dom
    end
    
  end
end