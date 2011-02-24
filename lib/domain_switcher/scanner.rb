module DomainSwitcher
  class Scanner

    @@domain_cache = {}
    
    def initialize(domains)
      @domains = domains

      domains.each do |d|
        @@domain_cache[d.domain] = d
      end
    end

    def scan_domain(host)
      @@domain_cache[host]
    end
    
  end
end